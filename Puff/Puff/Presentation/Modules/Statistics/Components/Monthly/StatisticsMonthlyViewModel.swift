//
//  StatisticsMonthlyViewModel.swift
//  Puff
//
//  Created by Никита Куприянов on 17.10.2024.
//

import SwiftUI

final class StatisticsMonthlyViewModel: ObservableObject {
    @AppStorage("smokesCount") private(set) var smokesCount: [Int] = []
    @AppStorage("smokesDates") private(set) var smokesDates: [Date] = []

    @AppStorage("planLimits") private(set) var planLimits: [Int] = Array(repeating: 100, count: 21)
    @AppStorage("isPlanStarted") private(set) var isPlanStarted: Bool = false
    @AppStorage("planStartDate") private(set) var planStartDate: Int?

    @Published var currentMonthRealValues: [Int?] = []
    @Published var currentMonthEstimatedValues: [Int?] = []

    @Published var monthForDate: Date = .now {
        didSet {
            updateMonth()
            updateMonthValues()
        }
    }

    private var currentMonth: [Date] = []
    private let calendar = Calendar.current

    init() {
        updateMonth()
        print("CMMM", currentMonth)
        updateMonthValues()
    }

    func updateMonthValues() {
        currentMonthRealValues = []
        currentMonthEstimatedValues = []

        var newRealValues: [Int?] = []
        var newEstimatedValues: [Int?] = []

        for day in currentMonth {
            let limit = getLimitForDate(day)

            if let index = smokesDates.firstIndex(where: { calendar.isDate(day, inSameDayAs: $0) }) {
                newRealValues.append(smokesCount[index])
                newEstimatedValues.append(limit)
            } else {
                newRealValues.append(nil)
                newEstimatedValues.append(limit)
            }
        }

        currentMonthRealValues = newRealValues
        currentMonthEstimatedValues = newEstimatedValues
    }

    private func updateMonth() {
        var monthDates: [Date] = []

        var current: Date = (currentMonth.last ?? .now).tomorrow.startOfMonth.startOfDate
        var end: Date = current.endOfMonth.startOfDate

        while current <= end {
            monthDates.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current) ?? .now
        }

        currentMonth = monthDates
    }

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