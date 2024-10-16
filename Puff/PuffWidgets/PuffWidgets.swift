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
        SimpleEntry(date: Date(), count: 10)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), count: 10)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let count = defaults.array(forKey: "newSmokesCount") as? [Int] ?? [100000]

        let timeline = Timeline(
            entries: [SimpleEntry(date: .now, count: count.last ?? -1)],
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

    var body: some View {
        VStack(spacing: 12) {
            Text("\(entry.count)\(500)")
                .font(.semibold26)


        }
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
        .configurationDisplayName("Widgets.HomeScreenDescription".l)
        .description("Widgets.HomeScreenDescription".l)
        .supportedFamilies([.systemSmall])
    }
}
