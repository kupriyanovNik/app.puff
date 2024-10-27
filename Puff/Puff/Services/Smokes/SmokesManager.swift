//
//  SmokesManager.swift
//  Puff
//
//  Created by Никита Куприянов on 27.09.2024.
//

import Foundation
import SwiftUI
import WidgetKit

final class SmokesManager: ObservableObject {

    // MARK: - Property Wrappers

    @Published var realPlanDayIndex: Int = 0

    @AppStorage("firstSmokeDate") var dateOfFirstSmoke: Int?

    @AppStorage("isPlanStarted") private(set) var isPlanStarted: Bool = false
    @AppStorage("isPlanEnded") private(set) var isPlanEnded: Bool = false {
        didSet {
            NotificationManager.shared.removeAllNotifications()
        }
    }

    @AppStorage("currentDayIndex") private(set) var currentDayIndex: Int = 0 {
        didSet {
            defaults.set(currentDayIndex, forKey: "newCurrentDayIndex")
            defaults.synchronize()

            WidgetCenter.shared.reloadAllTimelines()

            if currentDayIndex != oldValue {
                // чтобы обновление для реактивно пришло в просто тапалку для юзеров без премиума
                addNewDate(auto: false)
                WidgetCenter.shared.reloadTimelines(ofKind: "PuffWidgets.HomeScreenWidget")
            }
        }
    }

    @AppStorage("daysInPlan") private(set) var daysInPlan: Int = 21
    @AppStorage("planLimits") private(set) var planLimits: [Int] = Array(repeating: 10000, count: 21)
    @AppStorage("planCounts") private(set) var planCounts: [Int] = Array(repeating: 0, count: 21)

    @AppStorage("planStartDate") private(set) var planStartDate: Int?
    @AppStorage("dateOfLastSmoke") private(set) var dateOfLastSmoke: Int?

    @AppStorage("smokesCount") private(set) var smokesCount: [Int] = []
    @AppStorage("smokesDates") private(set) var smokesDates: [Date] = []

    @AppStorage("smokesHours") var smokesHours: [Int] = Array(repeating: 0, count: 24)

    // MARK: - Inits

    init() {
        checkIsNewDay()

        timer = .scheduledTimer(
            timeInterval: 2,
            target: self,
            selector: #selector(checkIsNewDay),
            userInfo: nil,
            repeats: true
        )

        RunLoop.current.add(timer!, forMode: RunLoop.Mode.default)
    }

    // MARK: - Private Properties

    private let calendar = Calendar.current

    private weak var timer: Timer?

    // MARK: - Internal Properties

    var todaySmokes: Int {
        if isPlanStarted {
            return planCounts[currentDayIndex]
        }

        if let index = smokesDates.firstIndex(where: { calendar.isDateInToday($0) }) {
            return smokesCount[max(0, index)]
        }

        return 0
    }

    var todayLimit: Int { planLimits[max(0, min(currentDayIndex, daysInPlan - 1))] }

    var isLastDayOfPlan: Bool { currentDayIndex + 1 == daysInPlan }

    var isTodayLimitExceeded: Bool { todaySmokes > todayLimit }

    var yesterdayCount: Int {
        let yesterdayIndex = currentDayIndex - 1
        guard yesterdayIndex >= 0 else {
            return 0
        }

        return planCounts[yesterdayIndex]
    }

    var yesterdayLimit: Int {
        let yesterdayIndex = currentDayIndex - 1
        guard yesterdayIndex >= 0 else {
            return 0
        }

        return planLimits[yesterdayIndex]
    }

    var isYesterdayLimitExceeded: Bool { yesterdayCount > yesterdayLimit }

    var isDayAfterPlanEnded: Bool { realPlanDayIndex >= planLimits.count }

    // MARK: - Internal Functions

    func startPlan(period: ActionMenuPlanDevelopingPeriod, smokesPerDay: Int) {
        if smokesPerDay < todaySmokes {
            if let index = smokesDates.firstIndex(where: { calendar.isDateInToday($0) }) {
                smokesCount[index] = 0
            }
        }

        planStartDate = Int(Date().timeIntervalSince1970)
        defaults.set(planStartDate, forKey: "newPlanStartDate")

        daysInPlan = period.rawValue

        planLimits = getLimits(for: period, smokesPerDay: smokesPerDay)
        planCounts = Array(repeating: 0, count: daysInPlan)
        
        if let index = smokesDates.firstIndex(where: { calendar.isDateInToday($0) }) {
            planCounts[0] = smokesCount[index]
        }

        realPlanDayIndex = 0
        currentDayIndex = 0

        isPlanStarted = true
        isPlanEnded = false

        defaults.set(true, forKey: "newIsPlanStarted")
        defaults.set(false, forKey: "newIsPlanEnded")

        defaults.set(planCounts, forKey: "newPlanCounts")
        defaults.set(planLimits, forKey: "newPlanLimits")
        defaults.set(currentDayIndex, forKey: "newCurrentDayIndex")

        defaults.synchronize()

        if #available(iOS 18.0, *) {
            WidgetCenter.shared.invalidateRelevance(ofKind: "PuffWidgets.HomeScreenWidget")
        }

        WidgetCenter.shared.reloadAllTimelines()

        AnalyticsManager.logEvent(event: .startedPlan(initialSmokes: smokesPerDay, daysInPlan: period.rawValue))
    }

    func puff() {
        dateOfLastSmoke = Int(Date().timeIntervalSince1970)
        defaults.set(dateOfLastSmoke, forKey: "newDateOfLastSmoke")

        if dateOfFirstSmoke == nil {
            dateOfFirstSmoke = Int(Date().timeIntervalSince1970)
        }

        smokesHours[calendar.component(.hour, from: .now)] += 1

        if isPlanStarted {
            if planCounts.count > currentDayIndex {
                planCounts[realPlanDayIndex] += 1
            }
        }

        if let index = smokesDates.firstIndex(where: { calendar.isDateInToday($0) }) {
            smokesCount[index] += 1
        } else {
            addNewDate()
        }

        defaults.set(smokesCount, forKey: "newSmokesCount")
        defaults.set(planCounts, forKey: "newPlanCounts")
        defaults.set(smokesDates, forKey: "newSmokesDates")

        defaults.synchronize()

        WidgetCenter.shared.reloadAllTimelines()
    }

    func addMoreSmokes(_ count: Int) {
        if let period = ActionMenuPlanDevelopingPeriod(rawValue: planLimits.count) {
            if let firstDayLimit = planLimits.first {
                if currentDayIndex == 0 {
                    planLimits = getLimits(for: period, smokesPerDay: todaySmokes + count)
                    NotificationManager.shared.removeAllNotifications()
                    NotificationManager.shared.scheduleNotifications(limits: planLimits)
                } else if currentDayIndex == 1 {
                    var newPlan = getLimits(for: period, smokesPerDay: todaySmokes + count)
                    let _ = newPlan.popLast()

                    planLimits = [firstDayLimit] + newPlan

                    NotificationManager.shared.removeAllNotifications()
                    NotificationManager.shared.scheduleNotifications(limits: newPlan)
                }

                AnalyticsManager.logEvent(event: .addedMoreSmokes(count: count))
            }
        }

        defaults.set(planLimits, forKey: "newPlanLimits")

        defaults.synchronize()
        WidgetCenter.shared.reloadTimelines(ofKind: "PuffWidgets.HomeScreenWidget")
    }

    func extendPlanForOneDay() {
        var newPlan: [Int] = []
        let planUntilToday = planLimits[0..<currentDayIndex]

        newPlan.append(contentsOf: planUntilToday)
        if let last = planUntilToday.last {
            newPlan.append(last)
        }
        newPlan.append(contentsOf: planLimits[currentDayIndex...])

        planLimits = newPlan
        planCounts.append(0)
        daysInPlan = planLimits.count

        if isLastDayOfPlan {
            AnalyticsManager.logEvent(event: .extendedPlanInLastDay)
        } else {
            AnalyticsManager.logEvent(event: .extendedPlan)
        }

        defaults.set(planCounts, forKey: "newPlanCounts")
        defaults.set(planLimits, forKey: "newPlanLimits")

        defaults.synchronize()
        WidgetCenter.shared.reloadTimelines(ofKind: "PuffWidgets.HomeScreenWidget")
    }

    func addDay() {
        // надобавлять до 28 дня с лимитом как в 21
        let diff: Int = realPlanDayIndex - planCounts.count
        // если -1, то сам тыкнул что готов бросить

        if diff > -1 {
            if let limit = planLimits.last {
                for _ in 0..<diff + 1 {
                    planLimits.append(limit)
                    planCounts.append(0)
                    daysInPlan += 1
                }
            }
        } else {
            if let last = planLimits.last {
                planLimits.append(last)
                planCounts.append(0)
                daysInPlan += 1
            }
        }

        defaults.set(planCounts, forKey: "newPlanCounts")
        defaults.set(planLimits, forKey: "newPlanLimits")

        defaults.synchronize()
        WidgetCenter.shared.reloadTimelines(ofKind: "PuffWidgets.HomeScreenWidget")
    }

    func endPlan() {
        withAnimation(.mainAnimation) {
            isPlanEnded = true
        }

        defaults.set(true, forKey: "newIsPlanEnded")

        defaults.synchronize()
        WidgetCenter.shared.reloadAllTimelines()
    }

    func resetPlan() {
        isPlanStarted = false
        isPlanEnded = false
        currentDayIndex = 0
        realPlanDayIndex = 0
        planStartDate = nil

        planLimits = Array(repeating: 10000, count: 21)
        planCounts = Array(repeating: 0, count: 21)

        defaults.set(planCounts, forKey: "newPlanCounts")
        defaults.set(planLimits, forKey: "newPlanLimits")
        defaults.set(false, forKey: "newIsPlanStarted")
        defaults.set(false, forKey: "newIsPlanEnded")

        defaults.set(nil, forKey: "newPlanStartDate")

        defaults.synchronize()

        WidgetCenter.shared.reloadAllTimelines()
    }

    @objc func checkIsNewDay() {
        restore()

        if let planStartDate {
            let startOfToday = calendar.startOfDay(for: .now)
            let startOfStartOfPlan = calendar.startOfDay(
                for: Date(timeIntervalSince1970: TimeInterval(planStartDate))
            ).timeIntervalSince1970

            let diff = Int(startOfToday.timeIntervalSince1970) - Int(startOfStartOfPlan)

            let diffDays = Int(diff / 86400)

            currentDayIndex = min(planLimits.count - 1, diffDays)
            realPlanDayIndex = diffDays
        }
    }

    func restore() {
        if defaults.bool(forKey: "hasAddedPuffsUsingIntent") {
            if let counts = defaults.array(forKey: "newSmokesCount") as? [Int] {
                self.smokesCount = counts
            }

            if let dates = defaults.array(forKey: "newSmokesDates") as? [Date] {
                smokesDates = dates
            }

            if let newPlanCounts = defaults.array(forKey: "newPlanCounts") as? [Int] {
                self.planCounts = newPlanCounts
            }

            let dateOfLastSmokeInMillis = defaults.integer(forKey: "newDateOfLastSmoke")
            if dateOfLastSmokeInMillis != 0 {
                self.dateOfLastSmoke = dateOfLastSmokeInMillis
            }

            self.currentDayIndex = defaults.integer(forKey: "newCurrentDayIndex")

            defaults.set(false, forKey: "hasAddedPuffsUsingIntent")

            defaults.synchronize()
        }
    }

    // MARK: - Private Functions

    private func getLimits(for period: ActionMenuPlanDevelopingPeriod, smokesPerDay: Int) -> [Int] {
        var limits: [Int] = []

        for i in stride(from: 1, to: period.rawValue + 1, by: 1) {
            if i == 1 {
                limits.append(smokesPerDay)
            } else {
                if let current = limits.last {
                    let c = current - (current / (period.rawValue - i + 2))
                    limits.append(c)
                }
            }
        }

        return limits
    }

    private func addNewDate(auto: Bool = true) {
        smokesDates.append(.now)
        smokesCount.append(auto ? 1 : 0)
    }
}
