//
//  SmokesManager.swift
//  Puff
//
//  Created by Никита Куприянов on 27.09.2024.
//

import Foundation
import SwiftUI

final class SmokesManager: ObservableObject {
//    @AppStorage("isPlanCreated") var isPlanCreated: Bool = false
    @Published var isPlanCreated: Bool = false

    //    @AppStorage("isPlanEnded") var isPlanEnded: Bool = false
    @Published var isPlanEnded: Bool = false

    @AppStorage("currentDayIndex") var currentDayIndex: Int = 0
    @AppStorage("daysInPlan") var daysInPlan: Int = 21
    @AppStorage("smokesForDay") var smokesForDay: [Int] = []

//    @AppStorage("dateOfLastSmoke") var dateOfLastSmoke: Date?
     var dateOfLastSmoke: Date?

    @AppStorage("planLimits") var planLimits: [Int] = Array(repeating: 100, count: 21)
    @AppStorage("planCounts") var planCounts: [Int] = Array(repeating: 0, count: 21)

    @AppStorage("firstOpenAppDate") var firstOpenAppDate: Date = .now
    @AppStorage("smokesCountForDate") var smokesCountForDate: [Int] = []

    var todayLimit: Int {
        planLimits[currentDayIndex]
    }

    var isLastDay: Bool {
        currentDayIndex + 1 == daysInPlan
    }

    var isTodayLimitExceeded: Bool {
        todaySmokes > todayLimit
    }

    var todaySmokes: Int { planCounts[currentDayIndex] }

    func startPlan() {
        isPlanCreated = true
    }

    func puff() {
        dateOfLastSmoke = .now

        if isPlanCreated {
            planCounts[currentDayIndex] += 1
        }
    }
}
