//
//  PuffIntent.swift
//  PuffWidgetsExtension
//
//  Created by Никита Куприянов on 19.10.2024.
//

import Foundation
import WidgetKit
import AppIntents

struct PuffIntent: AppIntent {

    static var title: LocalizedStringResource = "Puff"
    static var description = IntentDescription("Adding a Puff")

    static var openAppWhenRun: Bool = false

    @MainActor
    func perform() async throws -> some IntentResult {
        let isPlanEnded = defaults.bool(forKey: "newIsPlanEnded")
        let isPlanStarted = defaults.bool(forKey: "newIsPlanStarted")

        defaults.set(true, forKey: "hasAddedPuffsUsingIntent")

        if (!isPlanEnded && isPlanStarted) || !isPlanStarted {
            var counts = defaults.array(forKey: "newSmokesCount") as? [Int] ?? [0]
            var dates = defaults.array(forKey: "newSmokesDates") as? [Date] ?? [.now]

            let currentDayIndex = defaults.integer(forKey: "newCurrentDayIndex")
            var planCounts = defaults.array(forKey: "newPlanCounts") as? [Int] ?? [1000]
            let planLimits = defaults.array(forKey: "newPlanLimits") as? [Int] ?? [-1]
            var currentDayIndexInArray = min(planCounts.count - 1, currentDayIndex)

            if counts.count > 0 {
                if let lastDate = dates.last, Calendar.current.isDateInToday(lastDate) {
                    counts[counts.count - 1] += 1
                } else {
                    counts.append(1)
                    dates.append(.now)
                }

                if isPlanStarted {
                    let realCurrentDayIndex = getRealCurrentIndex(limits: planLimits)

                    if let realCurrentDayIndex, realCurrentDayIndex > currentDayIndexInArray {
                        currentDayIndexInArray = realCurrentDayIndex
                        defaults.set(currentDayIndexInArray, forKey: "newCurrentDayIndex")
                    }

                    if currentDayIndex < 2 || planCounts[currentDayIndexInArray] < planLimits[currentDayIndexInArray] {
                        planCounts[currentDayIndexInArray] += 1
                    }
                }

                defaults.set(counts, forKey: "newSmokesCount")
                defaults.set(dates, forKey: "newSmokesDates")

                defaults.set(planCounts, forKey: "newPlanCounts")

                defaults.set(Date().timeIntervalSince1970, forKey: "newDateOfLastSmoke")

                defaults.synchronize()
            }
        } else {
            // TODO: - open app and tell that plan is ended
            // ^ desided not to do!
        }

        WidgetCenter.shared.reloadTimelines(ofKind: "PuffWidgets.HomeScreenWidget")

        return .result()
    }

    private func getRealCurrentIndex(limits: [Int]) -> Int? {
        let calendar = Calendar.current
        let planStartDate = defaults.integer(forKey: "newPlanStartDate")

        if planStartDate != 0 {
            let startOfToday = calendar.startOfDay(for: .now)
            let startOfStartOfPlan = calendar.startOfDay(
                for: Date(timeIntervalSince1970: TimeInterval(planStartDate))
            ).timeIntervalSince1970

            let diff = Int(startOfToday.timeIntervalSince1970) - Int(startOfStartOfPlan)

            let diffDays = Int(diff / 86400)

            return min(limits.count - 1, diffDays)
        }

        return nil
    }
}
