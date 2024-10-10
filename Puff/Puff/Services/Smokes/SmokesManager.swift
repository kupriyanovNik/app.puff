//
//  SmokesManager.swift
//  Puff
//
//  Created by Никита Куприянов on 27.09.2024.
//

import Foundation
import SwiftUI

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
            if currentDayIndex != oldValue {
                // чтобы обновление для реактивно пришло в просто тапалку для юзеров без премиума
                addNewDate(auto: false)
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
            timeInterval: 3,
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
        if let index = smokesDates.firstIndex(where: { calendar.isDateInToday($0) }) {
            return smokesCount[index]
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

        AnalyticsManager.logEvent(event: .startedPlan(initialSmokes: smokesPerDay, daysInPlan: period.rawValue))
    }

    func puff() {
        dateOfLastSmoke = Int(Date().timeIntervalSince1970)

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
    }

    func addMoreSmokes(_ count: Int) {
        if let period = ActionMenuPlanDevelopingPeriod(rawValue: planLimits.count) {
            if let firstDayLimit = planLimits.first {

                if currentDayIndex == 0 {
                    planLimits = getLimits(for: period, smokesPerDay: todaySmokes + count)
                } else if currentDayIndex == 1 {
                    var newPlan = getLimits(for: period, smokesPerDay: todaySmokes + count)
                    let _ = newPlan.popLast()

                    planLimits = [firstDayLimit] + newPlan
                }

                AnalyticsManager.logEvent(event: .addedMoreSmokes(count: count))
            }
        }
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
    }

    func endPlan() {
        isPlanEnded = true
    }

    func resetPlan() {
        isPlanStarted = false
        isPlanEnded = false
        currentDayIndex = 0
        realPlanDayIndex = 0
        planStartDate = nil
    }

    @objc func checkIsNewDay() {
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
