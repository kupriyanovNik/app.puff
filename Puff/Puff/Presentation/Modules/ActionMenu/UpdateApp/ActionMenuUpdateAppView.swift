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
            LottieView(name: "ActionMenuUpdateAppAnimation", loopMode: .loop, delay: 0.3)
                .frame(68)
                .padding(.bottom, -14)

            VStack(spacing: 18) {
                Text("ActionMenuUpdateApp.Title".l)
                    .font(.bold22)
                    .foregroundStyle(Palette.textPrimary)

                Text("ActionMenuUpdateApp.Description".l)
                    .font(.semibold16)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Palette.textSecondary)
            }
            .padding(.horizontal, 12)

            AccentButton(text: "ActionMenuUpdateApp.GoToAppStore".l) {
                AnalyticsManager.logEvent(event: .openedAppStoreFromUpdateActionMenu)
                HapticManager.actionMenusButton()

                "https://apps.apple.com/app/id6717609578".openURL()

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
