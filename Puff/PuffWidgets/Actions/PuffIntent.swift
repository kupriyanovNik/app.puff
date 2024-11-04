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

        // ибо юзер дефолтсы по нулям
        if !defaults.bool(forKey: "hasOpenedAppAfterUpdate") {
            return .result()
        }

        // чтобы нельзя было отметить затяжку если план закончен
        if !((!isPlanEnded && isPlanStarted) || !isPlanStarted) { return .result() }

        // чтобы в SmokesManager.restore() не делать лишние пересчеты
        defaults.set(true, forKey: "hasAddedPuffsUsingIntent")

        var planCounts = defaults.array(forKey: "newPlanCounts") as? [Int] ?? [0]
        let planLimits = defaults.array(forKey: "newPlanLimits") as? [Int] ?? [-1]

        if ableToPuff(limits: planLimits, counts: planCounts) {
            var smokesCounts = defaults.array(forKey: "newSmokesCount") as? [Int]
            var smokesDates = defaults.array(forKey: "newSmokesDates") as? [Date] ?? [.now]

            var currentDayIndexInArray = min(planCounts.count - 1, defaults.integer(forKey: "newCurrentDayIndex"))

            if isPlanStarted && (smokesCounts != nil) {
                let realCurrentDayIndex = getRealCurrentIndex(limits: planLimits)
                let dayIndexWithoutLimit = getRealCurrentIndexWithoutLimit(limits: planLimits)

                if (realCurrentDayIndex ?? 1) < 0 {
                    return .result()
                }

                if let realCurrentDayIndex, realCurrentDayIndex > currentDayIndexInArray {
                    currentDayIndexInArray = realCurrentDayIndex
                    defaults.set(currentDayIndexInArray, forKey: "newCurrentDayIndex")
                }

                if dayIndexWithoutLimit == realCurrentDayIndex {
                    planCounts[currentDayIndexInArray] += 1

                    justPuff(counts: &smokesCounts!, dates: &smokesDates)
                }

            } else if smokesCounts != nil {
                justPuff(counts: &smokesCounts!, dates: &smokesDates)
            }

            defaults.set(smokesCounts, forKey: "newSmokesCount")
            defaults.set(smokesDates, forKey: "newSmokesDates")

            defaults.set(planCounts, forKey: "newPlanCounts")

            defaults.set(Date().timeIntervalSince1970, forKey: "newDateOfLastSmoke")
        }

        defaults.synchronize()
        WidgetCenter.shared.reloadTimelines(ofKind: "PuffWidgets.HomeScreenWidget")

        return .result()
    }

    private func justPuff(counts: inout [Int], dates: inout [Date]) {
        if let lastDate = dates.last, Calendar.current.isDateInToday(lastDate) {
            counts[counts.count - 1] += 1
        } else {
            counts.append(1)
            dates.append(.now)
        }
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

    private func getRealCurrentIndexWithoutLimit(limits: [Int]) -> Int? {
        let calendar = Calendar.current
        let planStartDate = defaults.integer(forKey: "newPlanStartDate")

        if planStartDate != 0 {
            let startOfToday = calendar.startOfDay(for: .now)
            let startOfStartOfPlan = calendar.startOfDay(
                for: Date(timeIntervalSince1970: TimeInterval(planStartDate))
            ).timeIntervalSince1970

            let diff = Int(startOfToday.timeIntervalSince1970) - Int(startOfStartOfPlan)

            let diffDays = Int(diff / 86400)

            return diffDays
        }

        return nil
    }

    private func ableToPuff(limits: [Int], counts: [Int]) -> Bool {
        if !defaults.bool(forKey: "newIsPlanStarted") {
            return true
        }

        let calendar = Calendar.current

        let planStartDate = defaults.integer(forKey: "newPlanStartDate")

        if let currentDayIndexInArray = getRealCurrentIndex(limits: limits) {
            // запрещаем затягиваться больше лимита только в последний день
            return counts[currentDayIndexInArray] < limits[currentDayIndexInArray]
                || (currentDayIndexInArray < counts.count - 1)
        }
        
        if planStartDate != 0 {
            let startOfToday = calendar.startOfDay(for: .now)
            let startOfStartOfPlan = calendar.startOfDay(
                for: Date(timeIntervalSince1970: TimeInterval(planStartDate))
            ).timeIntervalSince1970

            let diff = Int(startOfToday.timeIntervalSince1970) - Int(startOfStartOfPlan)

            let diffDays = Int(diff / 86400)

            return diffDays <= limits.count
        }

        return true
    }
}
