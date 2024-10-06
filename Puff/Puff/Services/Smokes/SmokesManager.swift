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

    @AppStorage("isPlanStarted") private(set) var isPlanStarted: Bool = false
    @AppStorage("isPlanEnded") private(set) var isPlanEnded: Bool = false

    @AppStorage("currentDayIndex") private(set) var currentDayIndex: Int = 0 {
        didSet {
            if currentDayIndex != oldValue {
                // чтобы обновление для реактивно пришло в просто тапалку для юзеров без премиума
                addNewDate(auto: false)
            }
        }
    }

    @AppStorage("daysInPlan") private(set) var daysInPlan: Int = 21
    @AppStorage("planLimits") private(set) var planLimits: [Int] = Array(repeating: 100, count: 21)
    @AppStorage("planCounts") private(set) var planCounts: [Int] = Array(repeating: 0, count: 21)

    @AppStorage("planStartDate") private(set) var planStartDate: Int?
    @AppStorage("dateOfLastSmoke") private(set) var dateOfLastSmoke: Int?

    @AppStorage("smokesCount") private(set) var smokesCount: [Int] = []
    @AppStorage("smokesDates") private(set) var smokesDates: [Date] = []

    // MARK: - Inits

    init() {
        timer = .scheduledTimer(
            timeInterval: 3,
            target: self,
            selector: #selector(checkIsNewDay),
            userInfo: nil,
            repeats: true
        )

        RunLoop.current.add(timer!, forMode: RunLoop.Mode.default)

        print("startOfPlan", Date(timeIntervalSince1970: TimeInterval(planStartDate ?? 0)))
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

    var todayLimit: Int {
        if planLimits.count > currentDayIndex {
            return planLimits[currentDayIndex]
        }

        return 0
    }

    var isLastDayOfPlan: Bool { currentDayIndex + 1 >= daysInPlan }

    var isTodayLimitExceeded: Bool { todaySmokes > todayLimit }


    // MARK: - Internal Functions

    func startPlan(period: ActionMenuPlanDevelopingPeriod, smokesPerDay: Int) {
        isPlanStarted = true
        isPlanEnded = false

        if smokesPerDay < todaySmokes {
            if let index = smokesDates.firstIndex(where: { calendar.isDateInToday($0) }) {
                smokesCount[index] = 0
            }
        }

        planStartDate = Int(Date().timeIntervalSince1970)

        daysInPlan = period.rawValue

        planLimits = getLimits(for: period, smokesPerDay: smokesPerDay)
        planCounts = Array(repeating: 0, count: daysInPlan)
    }

    func puff() {
        dateOfLastSmoke = Int(Date().timeIntervalSince1970)

        if isPlanStarted {
            if planCounts.count > currentDayIndex {
                planCounts[currentDayIndex] += 1
            }
        }

        if let index = smokesDates.firstIndex(where: { calendar.isDateInToday($0) }) {
            smokesCount[index] += 1
        } else {
            addNewDate()
        }
    }

    func addDay() {
        
    }

    func endPlan() {
        isPlanEnded = true
    }

    func resetPlan() {
        isPlanStarted = false
        isPlanEnded = false
    }

    @objc func checkIsNewDay() {
        if let planStartDate {
            let startOfToday = calendar.startOfDay(for: .now)
            let startOfStartOfPlan = calendar.startOfDay(
                for: Date(timeIntervalSince1970: TimeInterval(planStartDate))
            ).timeIntervalSince1970

            let diff = Int(startOfToday.timeIntervalSince1970) - Int(startOfStartOfPlan)

            let diffDays = Int(diff / 86400)

            print(
                "today",
                Date(timeIntervalSince1970: startOfToday.timeIntervalSince1970),
                "splan",
                Date(timeIntervalSince1970: TimeInterval(startOfStartOfPlan)),
                diffDays
            )

            currentDayIndex = diffDays
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
