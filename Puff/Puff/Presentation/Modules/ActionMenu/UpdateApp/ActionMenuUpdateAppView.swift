//
//  ActionMenuUpdateAppView.swift
//  Puff
//
//  Created by Никита Куприянов on 17.11.2024.
//

import SwiftUI

struct ActionMenuUpdateAppView: View {

    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Image(.update)
                .resizable()
                .scaledToFit()
                .frame(68)
                .padding(.bottom, -14)

            VStack(spacing: 18) {
                Text("Обновите Puffless")
                    .font(.bold22)
                    .foregroundStyle(Palette.textPrimary)

                Text("Мы исправили критические баги и добавили новый функционал.")
                    .font(.semibold16)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Palette.textSecondary)
            }
            .padding(.horizontal, 12)

            AccentButton(text: "Обновить") {
                // TODO: INSERT APP LINK
                "".openURL()

                delay(0.5, action: onDismiss)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
    }
}

#Preview {
    ActionMenuUpdateAppView { }
}
