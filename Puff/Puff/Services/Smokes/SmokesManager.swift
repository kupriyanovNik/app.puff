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

    @AppStorage("isPlanStarted") var isPlanStarted: Bool = false
    @AppStorage("isPlanEnded") var isPlanEnded: Bool = false

    @AppStorage("currentDayIndex") var currentDayIndex: Int = 0 {
        didSet {
            // чтобы обновление для реактивно пришло в просто тапалку для юзеров без премиума
            addNewDate()
        }
    }

    @AppStorage("daysInPlan") var daysInPlan: Int = 21
    @AppStorage("planLimits") var planLimits: [Int] = Array(repeating: 100, count: 21)
    @AppStorage("planCounts") var planCounts: [Int] = Array(repeating: 0, count: 21)

    @AppStorage("planStartDate") var planStartDate: Date?
    @AppStorage("dateOfLastSmoke") var dateOfLastSmoke: Date?

    @AppStorage("smokesCount") var smokesCount: [Int] = []
    @AppStorage("smokesDates") var smokesDates: [Date] = []

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

        print("TS", todaySmokes)
        print("SC", smokesCount)
        print("SD", smokesDates)
        print("PC", planCounts[currentDayIndex])
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

    var todayLimit: Int { planLimits[currentDayIndex] }

    var isLastDayOfPlan: Bool { currentDayIndex + 1 == daysInPlan }

    var isTodayLimitExceeded: Bool { todaySmokes > todayLimit }


    // MARK: - Internal Functions

    func startPlan(period: ActionMenuPlanDevelopingPeriod, smokesPerDay: Int) {
        isPlanStarted = true

        planStartDate = .now

        daysInPlan = period.rawValue

        planLimits = getLimits(for: period, smokesPerDay: smokesPerDay)
        planCounts = Array(repeating: 0, count: daysInPlan)
    }

    func puff() {
        dateOfLastSmoke = .now

        if isPlanStarted {
            planCounts[currentDayIndex] += 1
        }

        if let index = smokesDates.firstIndex(where: { calendar.isDateInToday($0) }) {
            smokesCount[index] += 1
        } else {
            addNewDate()
        }
    }

    func resetPlan() {
        dateOfLastSmoke = nil
        isPlanStarted = false
        isPlanEnded = false
    }

    @objc func checkIsNewDay() {
        if let planStartDate {
            let diff = Date() - planStartDate

            let diffDays = Int(diff / 86400)

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

    private func addNewDate() {
        smokesDates.append(.now)
        smokesCount.append(0)
    }
}
