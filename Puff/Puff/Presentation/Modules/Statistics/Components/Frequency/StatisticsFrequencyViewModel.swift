//
//  StatisticsFrequencyViewModel.swift
//  Puff
//
//  Created by Никита Куприянов on 05.10.2024.
//

import SwiftUI

final class StatisticsFrequencyViewModel: ObservableObject {
    @AppStorage("smokesHours") private(set) var smokesHours: [Int] = Array(repeating: 0, count: 24)

    @AppStorage("smokesCount") private(set) var smokesCount: [Int] = []
    @AppStorage("smokesDates") private(set) var smokesDates: [Date] = []

    @Published var averageIntervalText: String = ""

    init() {
        averageIntervalText = getLastSmokeTimeString(for: getAverageBreakInSeconds())
    }

    private func getAverageBreakInSeconds() -> Int {
        let allSeconds = smokesDates.count * 86400
        let allSmokes = smokesCount.reduce(0, +)

        if allSmokes > 0 {
            return allSeconds / allSmokes
        }

        return 0
    }

    private func getLastSmokeTimeString(for diff: Int) -> String {
        let diff = Double(diff)

        let days = Int(diff / 86400)
        let hours = Int(diff / 3600)
        let minutes = Int(diff / 60)

        if Bundle.main.preferredLocalizations[0] == "ru" {
            return getLastSmokeTimeRussianString(days, hours, minutes)
        } else {
            if hours != 0 {
                if hours == 1 {
                    return "1 hour"
                } else {
                    return "\(hours) hours"
                }
            } else {
                if minutes != 0 {
                    if minutes == 1 {
                        return "1 minute"
                    } else {
                        return "\(minutes) minutes"
                    }
                } else {
                    return "Less then 1 minute"
                }
            }
        }
    }

    private func getLastSmokeTimeRussianString(_ days: Int, _ hours: Int, _ minutes: Int) -> String {
        if hours != 0 {
            if hours % 10 == 1 && hours % 100 != 11 {
                return "\(hours) час"
            } else if (hours % 10 >= 2 && hours % 10 <= 4) && !(hours % 100 >= 12 && hours % 100 <= 14) {
                return "\(hours) часа"
            } else {
                return "\(hours) часов"
            }
        } else {
            if minutes != 0 {
                if minutes % 10 == 1 && minutes % 100 != 11 {
                    return "\(minutes) минуту"
                } else if (minutes % 10 >= 2 && minutes % 10 <= 4) && !(minutes % 100 >= 12 && minutes % 100 <= 14) {
                    return "\(minutes) минуты"
                } else {
                    return "\(minutes) минут"
                }
            } else {
                return "Меньше 1 минуты"
            }
        }
    }
}
