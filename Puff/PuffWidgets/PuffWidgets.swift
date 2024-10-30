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
        SimpleEntry(date: Date(), count: 10, isEnded: false, dateOfLastSmoke: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), count: 10, isEnded: false, dateOfLastSmoke: nil)
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
                    isEnded: isPlanEnded,
                    dateOfLastSmoke: defaults.integer(forKey: "newDateOfLastSmoke")
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
    let dateOfLastSmoke: Int?
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
        Group {
            if entry.isEnded {
                planEndedView()
            } else {
                VStack(spacing: 12) {
                    Text(text) { str in
                        if let limit = entry.limit {
                            if let range = str.range(of: "/\(limit)") {
                                str[range].foregroundColor = .limit
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

    @ViewBuilder
    private func planEndedView() -> some View {
        Image(.planEndedBackground)
            .scaledToFill()
            .ignoresSafeArea()
            .scaleEffect(1.2)
            .overlay {
                VStack(spacing: 4) {
                    Text("Home.DontSmokeFor".l)
                        .font(.medium15)
                        .foregroundStyle(.limit)

                    Text(setTime())
                        .font(.bold28)
                        .foregroundStyle(.dontSmoke)
                }
            }
    }

    private func setTime() -> String {
        if let dateOfLastSmoke = entry.dateOfLastSmoke {
            return getLastSmokeTimeString(for: dateOfLastSmoke)
        } else {
            return "Home.RealyLongTime".l
        }
    }

    private func getLastSmokeTimeString(for dateInt: Int) -> String {
        let diff = Double(Date().timeIntervalSince1970) - Double(dateInt)

        let days = Int(diff / 86400)
        let hours = Int(diff / 3600)
        let minutes = Int(diff / 60)

        if Bundle.main.preferredLocalizations[0] == "ru" {
            return getLastSmokeTimeRussianString(days, hours, minutes)
        } else {
            if days != 0 {
                if days == 1 {
                    return "1 day"
                } else {
                    return "\(days) days"
                }
            } else {
                if hours != 0 {
                    if hours == 1 {
                        return "1 hour"
                    } else {
                        return "\(hours) hours"
                    }
                } else {
                    if minutes == 1 || minutes == 0 {
                        return "1 minute"
                    } else {
                        return "\(minutes) minutes"
                    }
                }
            }
        }
    }

    private func getLastSmokeTimeRussianString(_ days: Int, _ hours: Int, _ minutes: Int) -> String {
        if days != 0 {
            if days % 10 == 1 && days % 100 != 11 {
                return "\(days) день"
            } else if (days % 10 >= 2 && days % 10 <= 4) && !(days % 100 >= 12 && days % 100 <= 14) {
                return "\(days) дня"
            } else {
                return "\(days) дней"
            }
        } else {
            if hours != 0 {
                if hours % 10 == 1 && hours % 100 != 11 {
                    return "\(hours) час"
                } else if (hours % 10 >= 2 && hours % 10 <= 4) && !(hours % 100 >= 12 && hours % 100 <= 14) {
                    return "\(hours) часа"
                } else {
                    return "\(hours) часов"
                }
            } else {
                if (minutes % 10 == 1 && minutes % 100 != 11) || minutes == 1 {
                    return "\(minutes) минуту"
                } else if (minutes % 10 >= 2 && minutes % 10 <= 4) && !(minutes % 100 >= 12 && minutes % 100 <= 14) {
                    return "\(minutes) минуты"
                } else {
                    return "\(minutes) минут"
                }
            }
        }
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
                Label("Widgets.ControlCenterTitle".l, systemImage: "smoke.fill")
                    .symbolEffect(.bounce.byLayer)
            }
            .tint(.gray)
        }
        .displayName("Widgets.ControlCenterTitle")
    }
}
