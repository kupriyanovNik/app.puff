//
//  PuffWidgetProvider.swift
//  PuffWidgetsExtension
//
//  Created by Никита Куприянов on 22.11.2024.
//

import Foundation
import WidgetKit

struct PuffWidgetProvider: TimelineProvider {
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let isPlanEnded = defaults.bool(forKey: "newIsPlanEnded")
        let calendar = Calendar.current

        // MARK: - if plan ended we need to just update widget every day
        if isPlanEnded {
            let calendar = Calendar.current
            let currentDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: .now) ?? .now

            let entries = (0...50).map {
                SimpleEntry(
                    date: calendar.date(byAdding: .day, value: $0, to: currentDay) ?? currentDay,
                    count: 0,
                    limit: nil,
                    isEnded: true,
                    dateOfLastSmoke: defaults.integer(forKey: "newDateOfLastSmoke")
                )
            }

            completion(Timeline(entries: Array(entries), policy: .atEnd))
        } else {

            let counts = defaults.array(forKey: "newSmokesCount") as? [Int] ?? [0]
            let planCounts = defaults.array(forKey: "newPlanCounts") as? [Int] ?? [0]
            let planLimits = defaults.array(forKey: "newPlanLimits") as? [Int]

            let currentDayIndex = defaults.integer(forKey: "newCurrentDayIndex")
            let isPlanStarted = defaults.bool(forKey: "newIsPlanStarted")

            let todayCount = isPlanStarted ? planCounts[min(currentDayIndex, planCounts.count - 1)] : (counts.last ?? -1)

            let currentEntry = SimpleEntry(
                date: .now,
                count: todayCount,
                limit: (!isPlanStarted || planLimits == nil) ? nil : planLimits![currentDayIndex],
                isEnded: isPlanEnded,
                dateOfLastSmoke: defaults.integer(forKey: "newDateOfLastSmoke")
            )

            var currentDay: Date = .now.startOfDate

            if isPlanStarted {
                var nextEntries: [SimpleEntry] = [currentEntry]
                let daysInPlan = planCounts.count

                let maxIndex = daysInPlan - 1
                let seq = (1...(maxIndex - currentDayIndex))

                if currentDayIndex <= daysInPlan - 1 {
                    let entry = SimpleEntry(
                        date: currentDay.tomorrow,
                        count: planCounts[currentDayIndex + 1],
                        limit: (!isPlanStarted || planLimits == nil) ? nil : planLimits![currentDayIndex],
                        isEnded: isPlanEnded,
                        dateOfLastSmoke: defaults.integer(forKey: "newDateOfLastSmoke")
                    )
                    nextEntries.append(entry)
                }

                let timeline = Timeline(entries: nextEntries, policy: .atEnd)
                completion(timeline)
            } else {
                // только следующий день потому что если даже не тыкнет завтра то пофиг, будет просто
                let nextEvent = SimpleEntry(
                    date: currentDay.tomorrow,
                    count: 0,
                    limit: nil,
                    isEnded: false,
                    dateOfLastSmoke: 0
                )

                let timeline = Timeline(entries: [ currentEntry, nextEvent ], policy: .atEnd)
                completion(timeline)
            }
        }
    }
}

// MARK: - shit functions
extension PuffWidgetProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), count: 10, isEnded: false, dateOfLastSmoke: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), count: 10, isEnded: false, dateOfLastSmoke: 0)
        completion(entry)
    }
}
