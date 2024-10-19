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

    func perform() async throws -> some IntentResult {
        var counts = defaults.array(forKey: "newSmokesCount") as? [Int] ?? [0]
        let dates = defaults.array(forKey: "newSmokesDates") as? [Date] ?? [.now]

        let isPlanStarted = defaults.bool(forKey: "newIsPlanStarted")
        let isPlanEnded = defaults.bool(forKey: "newIsPlanEnded")

        let currentDayIndex = defaults.integer(forKey: "newCurrentDayIndex")
        var planCounts = defaults.array(forKey: "newPlanCounts") as? [Int] ?? [1000]
        let planLimits = defaults.array(forKey: "newPlanLimits") as? [Int] ?? [-1]
        let currentDayIndexInArray = min(planCounts.count - 1, currentDayIndex)

        if counts.count > 0 {
            counts[counts.count - 1] += 1
            planCounts[currentDayIndexInArray] += 1

            if planLimits[currentDayIndexInArray] < planCounts[currentDayIndexInArray] {

            }
        }

        defaults.set(counts, forKey: "newSmokesCount")
        defaults.set(Date().timeIntervalSince1970, forKey: "newDateOfLastSmoke")
        defaults.synchronize()

        WidgetCenter.shared.reloadAllTimelines()

        return .result()
    }
}
