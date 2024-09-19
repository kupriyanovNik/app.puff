//
//  PrimaryButton.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import SwiftUI

struct PrimaryButton: View {

    let text: String
    var font: Font = .custom("SF Pro Rounded", size: 16)
    var padding: EdgeInsets = .init(
        top: 16,
        leading: 0,
        bottom: 16,
        trailing: 0
    )
    var cornerRadius: CGFloat = 16
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
                    Color.white
                }
                .roundedCornerWithBorder(
                    lineWidth: 1,
                    borderColor: Color(hex: 0xF0F0F0),
                    radius: cornerRadius,
                    corners: [.allCorners]
                )
        }
    }
}

#Preview {
    PrimaryButton(text: "Менее 1 месяца", isDisabled: false) { }
        .padding(50)
}
