//
//  PuffHomeScreenWidget.swift
//  PuffWidgetsExtension
//
//  Created by Никита Куприянов on 22.11.2024.
//

import SwiftUI
import WidgetKit

struct PuffHomeScreenWidget: Widget {

    let kind: String = "PuffWidgets.HomeScreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PuffWidgetProvider()) { entry in
            PuffWidgetsEntryView(entry: entry)
                .containerBackground(.widgetBackground, for: .widget)
        }
        .configurationDisplayName("Widgets.HomeScreenTitle".l)
        .description("Widgets.HomeScreenDescription".l)
        .supportedFamilies([.systemSmall])
    }
}
