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

    @AppStorage("isPlanCreated") var isPlanCreated: Bool = false
//    @Published var isPlanCreated: Bool = false

        @AppStorage("isPlanEnded") var isPlanEnded: Bool = false
//    @Published var isPlanEnded: Bool = false

    @AppStorage("currentDayIndex") var currentDayIndex: Int = 0 {
        didSet {
            // чтобы обновление для реактивно пришло в просто тапалку для юзеров без премиума
            smokesForDay[Date()] = 0
        }
    }

    @AppStorage("daysInPlan") var daysInPlan: Int = 21
    @AppStorage("planLimits") var planLimits: [Int] = Array(repeating: 20, count: 21)
    @AppStorage("planCounts") var planCounts: [Int] = Array(repeating: 0, count: 21)

    @AppStorage("smokesForDay") var smokesForDay: [Date: Int] = [:]
    @AppStorage("planStartDate") var planStartDate: Date?
    @AppStorage("dateOfLastSmoke") var dateOfLastSmoke: Date?

//    @Published var currentDayIndex: Int = 0 {
//        didSet {
//            // чтобы обновление для реактивно пришло в просто тапалку для юзеров без премиума
//            smokesForDay[Date()] = 0
//        }
//    }
//    @Published var daysInPlan: Int = 21
//
//    @Published var planLimits: [Int] = Array(repeating: 20, count: 21)
//    @Published var planCounts: [Int] = Array(repeating: 0, count: 21)
//    @Published var smokesForDay: [Date: Int] = [:]

//    @Published var planStartDate: Date?

//    @Published var dateOfLastSmoke: Date?

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
    }

    // MARK: - Private Properties

    private let calendar = Calendar.current

    private weak var timer: Timer?

    // MARK: - Internal Properties

    var todaySmokes: Int { planCounts[currentDayIndex] }

    var todayLimit: Int { planLimits[currentDayIndex] }

    var isLastDayOfPlan: Bool { currentDayIndex + 1 == daysInPlan }

    var isTodayLimitExceeded: Bool { todaySmokes > todayLimit }


    // MARK: - Internal Functions

    func startPlan(period: ActionMenuPlanDevelopingPeriod, smokesPerDay: Int) {
        isPlanCreated = true

        planStartDate = .now

        daysInPlan = period.rawValue

        planLimits = getLimits(for: period, smokesPerDay: smokesPerDay)
        planCounts = Array(repeating: 0, count: daysInPlan)
    }

    func puff() {
        dateOfLastSmoke = .now

        if isPlanCreated {
            planCounts[currentDayIndex] += 1
        }

        if let index = smokesForDay.firstIndex(where: { key, value in
            calendar.isDateInToday(key)
        }) {
            let value = smokesForDay.keys[index]

            if let _ = smokesForDay[value] {
                smokesForDay[value]! += 1
            }
        } else {
            smokesForDay[Date()] = 1
        }
    }

    func resetPlan() {
        dateOfLastSmoke = nil
        isPlanCreated = false
        isPlanEnded = false
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

    @objc func checkIsNewDay() {
        if let planStartDate {
            let diff = Date() - planStartDate

            let diffDays = Int(diff / 86400)

            currentDayIndex = diffDays
        }
    }
}
