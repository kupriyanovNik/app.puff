//
//  SecondaryButton.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import SwiftUI

struct SecondaryButton: View {

    let text: String
    var font: Font = .semibold16
    var background: Color = Color(hex: 0xE7E7E7)
    var padding: EdgeInsets = .init(
        top: 16,
        leading: 0,
        bottom: 16,
        trailing: 0
    )
    var isDisabled: Bool = false

    var action: () -> Void

    var body: some View {
        DelayedButton(
            afterPressedOpacity: 0.88,
            isDisabled: isDisabled,
            action: action
        ) {
            Text(text)
                .font(font)
                .foregroundStyle(.black)
                .padding(padding)
                .hCenter()
                .background {
                    background
                }
                .cornerRadius(16)
        }
    }
}

#Preview {
    SecondaryButton(text: "Начать", isDisabled: false) { }
        .padding(50)
}
