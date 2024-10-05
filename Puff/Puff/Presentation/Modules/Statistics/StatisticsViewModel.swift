//
//  StatisticsViewModel.swift
//  Puff
//
//  Created by Никита Куприянов on 05.10.2024.
//

import Foundation
import SwiftUI

final class StatisticsViewModel: ObservableObject {
    @AppStorage("smokesCount") private(set) var smokesCount: [Int] = []
    @AppStorage("smokesDates") private(set) var smokesDates: [Date] = []

    @AppStorage("planLimits") private(set) var planLimits: [Int] = Array(repeating: 100, count: 21)
    @AppStorage("isPlanStarted") private(set) var isPlanStarted: Bool = false
    @AppStorage("planStartDate") private(set) var planStartDate: Int?

    @Published var currentWeekRealValues: [Int?] = []
    @Published var currentWeekEstimatedValues: [Int?] = []

    @Published var weekForDate: Date = .now {
        didSet {
            updateWeek()
            updateWeekValues()
        }
    }

    private var currentWeek: [Date] = []
    private let calendar = Calendar.current

    init() {
        updateWeek()
        updateWeekValues()
    }

    func updateWeekValues() {
        currentWeekRealValues = []
        currentWeekEstimatedValues = []

        for day in currentWeek {
            let limit = getLimitForDate(day)

            if let index = smokesDates.firstIndex(where: { calendar.isDate(day, inSameDayAs: $0) }) {
                currentWeekRealValues.append(smokesCount[index])
                currentWeekEstimatedValues.append(limit)
            } else {
                currentWeekRealValues.append(nil)
                currentWeekEstimatedValues.append(limit)
            }
        }
    }

    // correct
    private func updateWeek() {
        var weekDates: [Date] = []

        for i in 0..<7 {
            if let weekDate = calendar.date(byAdding: .day, value: i, to: weekForDate.startOfWeek) {
                weekDates.append(weekDate)
            }
        }

        currentWeek = weekDates
    }

    // corrent
    private func getLimitForDate(_ selectingDate: Date) -> Int? {
        guard isPlanStarted, let planStartDate else { return nil }

        let startDate = Date(timeIntervalSince1970: TimeInterval(planStartDate))

        for index in 0..<planLimits.count {
            if let date = calendar.date(byAdding: .day, value: index, to: startDate) {
                if calendar.isDate(selectingDate, inSameDayAs: date) {
                    return planLimits[index]
                }
            }
        }

        return nil
    }
}
