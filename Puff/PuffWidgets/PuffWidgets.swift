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
        SimpleEntry(date: Date(), count: 10, isEnded: false, dateOfLastSmoke: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), count: 10, isEnded: false, dateOfLastSmoke: 0)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let isPlanEnded = defaults.bool(forKey: "newIsPlanEnded")

        if isPlanEnded {
            let calendar = Calendar.current
            let entries = (0...100).map {
                SimpleEntry(
                    date: calendar.date(byAdding: .day, value: $0, to: .now) ?? .now,
                    count: 0,
                    limit: nil,
                    isEnded: true,
                    dateOfLastSmoke: defaults.integer(forKey: "newDateOfLastSmoke")
                )
            }

            completion(Timeline(entries: Array(entries), policy: .atEnd))
        } else {

            let counts = defaults.array(forKey: "newSmokesCount") as? [Int] ?? [0]
            let limits = defaults.array(forKey: "newPlanLimits") as? [Int]

            let currentDayIndex = defaults.integer(forKey: "newCurrentDayIndex")
            let isPlanStarted = defaults.bool(forKey: "newIsPlanStarted")

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
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let count: Int
    var limit: Int?
    let isEnded: Bool
    let dateOfLastSmoke: Int
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

    private var daysDontSmoke: Int {
        Int( (Double(Date().timeIntervalSince1970) - Double(entry.dateOfLastSmoke)) / 86400 )
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
                    Text(daysDontSmoke == 0 ? "Widgets.Broke".l : "Home.DontSmokeFor".l)
                        .font(.medium15)
                        .foregroundStyle(.limit)

                    Text(getTime())
                        .font(.bold28)
                        .foregroundStyle(.dontSmoke)
                }
            }
    }

    private func getTime() -> String {
        if entry.dateOfLastSmoke > 0 {
            return getLastSmokeTimeString(for: entry.dateOfLastSmoke)
        } else {
            return "Home.RealyLongTime".l
        }
    }

    private func getLastSmokeTimeString(for dateInt: Int) -> String {
        let diff = Double(Date().timeIntervalSince1970) - Double(dateInt)
        let days = Int(diff / 86400)

        if Bundle.main.preferredLocalizations[0] == "ru" {
            return getLastSmokeTimeRussianString(days)
        } else {
            return getLastSmokeTimeEnglishString(days)
        }
    }

    private func getLastSmokeTimeEnglishString(_ days: Int) -> String {
        if days > 0 {
            if days == 1 {
                return "1 day"
            } else {
                return "\(days) days"
            }
        }

        return "Today"
    }

    private func getLastSmokeTimeRussianString(_ days: Int) -> String {
        if days > 0 {
            if days % 10 == 1 && days % 100 != 11 {
                return "\(days) день"
            } else if (days % 10 >= 2 && days % 10 <= 4) && !(days % 100 >= 12 && days % 100 <= 14) {
                return "\(days) дня"
            } else {
                return "\(days) дней"
            }
        }

        return "Сегодня"
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

private extension PuffWidgetsEntryView {
    struct PuffWidgetButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            let isPressed = configuration.isPressed

            configuration.label
                .opacity(isPressed ? 0.8 : 1)
                .animation(.easeOut(duration: 0.15), value: isPressed)
        }
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
