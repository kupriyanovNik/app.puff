//
//  PuffWidgets.swift
//  PuffWidgets
//
//  Created by Никита Куприянов on 14.10.2024.
//

import WidgetKit
import SwiftUI
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), count: 10)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), count: 10)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let counts = defaults.array(forKey: "newSmokesCount") as? [Int] ?? [100000]

        let timeline = Timeline(
            entries: [SimpleEntry(date: .now, count: counts.last ?? -1)],
            policy: .atEnd
        )
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let count: Int
}

struct PuffWidgetsEntryView : View {
    var entry: Provider.Entry

    @Environment(\.colorScheme) var colorScheme

    private var buttonColor: Color {
        Color(hex: 0xB5D9FF, alpha: colorScheme == .light ? 1 : 0.92)
    }

    var body: some View {
        VStack(spacing: 12) {
            Text("\(entry.count)")
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

struct PuffWidgets: Widget {

    let kind: String = "PuffWidgets.HomeScreenWidget"

    @Environment(\.colorScheme) var colorScheme

    private var backgroundColor: Color {
        colorScheme == .light ? .white : .init(hex: 0x2C2C2E)
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PuffWidgetsEntryView(entry: entry)
                .containerBackground(backgroundColor, for: .widget)
        }
        .configurationDisplayName("Widgets.HomeScreenTitle".l)
        .description("Widgets.HomeScreenDescription".l)
        .supportedFamilies([.systemSmall])
    }
}

struct PuffIntent: AppIntent {
    static var title: LocalizedStringResource = "Puff"
    static var description = IntentDescription("Puff")

    func perform() async throws -> some IntentResult {
        var counts = defaults.array(forKey: "newSmokesCount") as? [Int] ?? [100000]

        if counts.count > 0 {
            counts[counts.count - 1] += 1
        }

        defaults.set(counts, forKey: "newSmokesCount")
        defaults.synchronize()

        return .result()
    }
}
