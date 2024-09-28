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

    @AppStorage("isPlanCreated") var isPlanCreated: Bool = true
//    @Published var isPlanCreated: Bool = false

        @AppStorage("isPlanEnded") var isPlanEnded: Bool = false
//    @Published var isPlanEnded: Bool = false

//    @AppStorage("currentDayIndex") var currentDayIndex: Int = 0
//    @AppStorage("daysInPlan") var daysInPlan: Int = 21
//    @AppStorage("planLimits") var planLimits: [Int] = Array(repeating: 20, count: 21)
//    @AppStorage("planCounts") var planCounts: [Int] = Array(repeating: 0, count: 21)
//    @AppStorage("smokesForDay") var smokesForDay: [Date: Int] = [:]

    @Published var currentDayIndex: Int = 0
    @Published var daysInPlan: Int = 21
    @Published var planLimits: [Int] = Array(repeating: 20, count: 21)
    @Published var planCounts: [Int] = Array(repeating: 0, count: 21)

    @Published var smokesForDay: [Date: Int] = [:]

//    @AppStorage("dateOfLastSmoke") var dateOfLastSmoke: Date?
    @Published var dateOfLastSmoke: Date?

    // MARK: - Private Properties

    private let calendar = Calendar.current

    // MARK: - Internal Properties

    var todaySmokes: Int { planCounts[currentDayIndex] }

    var todayLimit: Int { planLimits[currentDayIndex] }

    var isLastDayOfPlan: Bool { currentDayIndex + 1 == daysInPlan }

    var isTodayLimitExceeded: Bool { todaySmokes > todayLimit }


    // MARK: - Internal Functions

    func startPlan(period: ActionMenuPlanDevelopingPeriod) {
        isPlanCreated = true

        daysInPlan = period.rawValue

        planLimits = getLimits(for: period)
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

    private func getLimits(for period: ActionMenuPlanDevelopingPeriod) -> [Int] {
        [20, 20]
    }
}
