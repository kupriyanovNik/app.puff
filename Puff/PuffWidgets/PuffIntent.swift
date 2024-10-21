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
            let currentDayIndexInArray = min(planCounts.count - 1, currentDayIndex)

            if counts.count > 0 {
                if let lastDate = dates.last, Calendar.current.isDateInToday(lastDate) {
                    counts[counts.count - 1] += 1
                } else {
                    counts.append(1)
                }

                if isPlanStarted {
                    planCounts[currentDayIndexInArray] += 1
                }

                if !dates.contains(where: { Calendar.current.isDateInToday($0) }) {
                    dates.append(.now)
                }

                if isPlanStarted {
                    if planLimits[currentDayIndexInArray] < planCounts[currentDayIndexInArray] {
                        // TODO: - open app
                    }
                }
            }

            defaults.set(counts, forKey: "newSmokesCount")
            defaults.set(dates, forKey: "newSmokesDates")

            defaults.set(Date().timeIntervalSince1970, forKey: "newDateOfLastSmoke")

            defaults.synchronize()
        } else {
            // TODO: - open app and tell that plan is ended
        }

        WidgetCenter.shared.reloadTimelines(ofKind: "PuffWidgets.HomeScreenWidget")
        WidgetCenter.shared.reloadAllTimelines()

        return .result()
    }
}
