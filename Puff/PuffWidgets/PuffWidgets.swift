//
//  PuffWidgets.swift
//  PuffWidgets
//
//  Created by Никита Куприянов on 14.10.2024.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), count: 10, isEnded: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), count: 10, isEnded: false)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let counts = defaults.array(forKey: "newSmokesCount") as? [Int] ?? [0]
        let limits = defaults.array(forKey: "newPlanLimits") as? [Int]

        let currentDayIndex = defaults.integer(forKey: "newCurrentDayIndex")
        let isPlanStarted = defaults.bool(forKey: "newIsPlanStarted")
        let isPlanEnded = defaults.bool(forKey: "newIsPlanEnded")

        let timeline = Timeline(
            entries: [
                SimpleEntry(
                    date: .now,
                    count: counts.last ?? -1,
                    limit: (!isPlanStarted || limits == nil) ? nil : limits![currentDayIndex],
                    isEnded: isPlanEnded
                )
            ],
            policy: .atEnd
        )

        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let count: Int
    var limit: Int?
    let isEnded: Bool
}

struct PuffWidgetsEntryView : View {
    var entry: Provider.Entry

    @Environment(\.colorScheme) var colorScheme

    private var buttonColor: Color {
        Color(hex: 0xB5D9FF, alpha: colorScheme == .light ? 1 : 0.92)
    }

    private var text: String {
        if let limit = entry.limit {
            return "\(entry.count)/\(limit)"
        }

        return "\(entry.count)"
    }

    var body: some View {
        VStack(spacing: 12) {
            Text(text) { str in
                if let limit = entry.limit {
                    if let range = str.range(of: "/\(limit)") {
                        str[range].foregroundColor = Color(hex: 0x030303, alpha: 0.22)
                    }
                }
            }
            .id(entry.count)
            .font(.bold26)
            .transition(
                .asymmetric(
                    insertion: .scale(scale: 1.035),
                    removal: .identity
                )
            )

            button()
        }
    }

    @ViewBuilder
    private func button() -> some View {
        Button(intent: PuffIntent()) {
            RoundedRectangle(cornerRadius: 16)
                .fill(buttonColor)
                .overlay {
                    Image(.puffWidgetPlus)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 42, height: 42)
                }
        }
        .buttonStyle(PuffWidgetButtonStyle())
    }
}

struct PuffHomeScreenWidget: Widget {

    let kind: String = "PuffWidgets.HomeScreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PuffWidgetsEntryView(entry: entry)
                .containerBackground(.widgetBackground, for: .widget)
        }
        .configurationDisplayName("Widgets.HomeScreenTitle".l)
        .description("Widgets.HomeScreenDescription".l)
        .supportedFamilies([.systemSmall])
    }
}

@available(iOS 18.0, *)
struct PuffControlCenterWidget: ControlWidget {

    let kind: String = "PuffWidgets.ControlCenterWidget"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetButton(action: PuffIntent()) {
                Label("Добавить затяжку", image: "custom.cloud.fill.badge.plus")
                    .symbolEffect(.bounce, options: .nonRepeating)
            }
        }
        .displayName("Добавить затяжку")
    }
}
