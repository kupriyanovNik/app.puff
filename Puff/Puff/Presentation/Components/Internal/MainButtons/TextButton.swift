//
//  TextButton.swift
//  Puff
//
//  Created by Никита Куприянов on 19.09.2024.
//

import SwiftUI

struct TextButton: View {

    var text: String
    var color: Color = Color(hex: 0x0303034D).opacity(0.3)
    var padding: EdgeInsets = .init(top: 10, leading: 1, bottom: 10, trailing: 1)
    var font: Font = .callout

    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(font)
                .foregroundStyle(color)
                .padding(padding)
        }
        .buttonStyle(TextButtonStyle())
    }
}

#Preview {
    TextButton(text: "Начать") {}
}

struct TextButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.88 : 1)
            .animation(.smooth, value: configuration.isPressed)
    }
}
