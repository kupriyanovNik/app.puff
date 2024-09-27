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

    @AppStorage("currentDayIndex") var currentDayIndex: Int = 8
    @AppStorage("daysInPlan") var daysInPlan: Int = 21

    @AppStorage("planLimits") var planLimits: [Int] = Array(repeating: 500, count: 21)
    @AppStorage("planCounts") var planCounts: [Int] = Array(repeating: 200, count: 21)

    var todayLimit: Int {
        planLimits[currentDayIndex]
    }

    var isLastDay: Bool {
        currentDayIndex + 1 == daysInPlan
    }

    func startPlan() {
        isPlanCreated = true
    }
}
