//
//  PuffWidgetButtonStyle.swift
//  PuffWidgetsExtension
//
//  Created by Никита Куприянов on 16.10.2024.
//

import SwiftUI

struct PuffWidgetButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed

        configuration.label
            .opacity(isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.15), value: isPressed)
    }
}
