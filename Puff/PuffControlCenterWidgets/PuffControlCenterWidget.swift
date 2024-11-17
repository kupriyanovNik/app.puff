//
//  PuffControlCenterWidget.swift
//  PuffControlCenterWidget
//
//  Created by Никита Куприянов on 27.10.2024.
//

import WidgetKit
import SwiftUI

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
