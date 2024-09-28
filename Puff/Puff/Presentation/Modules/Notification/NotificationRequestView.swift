//
//  NotificationRequestView.swift
//  Puff
//
//  Created by Никита Куприянов on 22.09.2024.
//

import SwiftUI

struct NotificationRequestView: View {

    @AppStorage("hasSkippedNotificationRequest") var hasSkippedNotificationRequest: Bool = true

    var action: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            mockNotificationView()

            VStack(spacing: 16) {
                Text("Поможем не забывать отмечать затяжки")
                    .font(.bold28)
                    .foregroundStyle(Palette.textPrimary)

                Text("Разрешите присылать вам уведомления, чтобы мы смогли помочь вам сформировать новую привычку")
                    .font(.medium16)
                    .foregroundStyle(Palette.textSecondary)
                    .padding(.horizontal, 10)
            }
            .multilineTextAlignment(.center)

            Spacer()

            bottomView()
        }
        .padding(.horizontal, 20)
        .prepareForStackPresentationInOnboarding()
    }

    @ViewBuilder
    private func mockNotificationView() -> some View {
        HStack(spacing: 14) {
            Image(.appIcon)
                .resizable()
                .scaledToFit()
                .frame(44)

            VStack(alignment: .leading, spacing: 7) {
                Capsule()
                    .fill(Color(hex: 0xCFCFCF))
                    .frame(width: 150, height: 7)

                Capsule()
                    .fill(Color(hex: 0xDEDEDE))
                    .frame(width: 100, height: 7)

                Capsule()
                    .fill(Color(hex: 0xDEDEDE))
                    .frame(width: 50, height: 7)
            }
            .padding(.trailing, 8)

        }
        .padding(14)
        .background {
            Color(hex: 0xF0F0F0)
                .cornerRadius(20)
        }
    }

    @ViewBuilder
    private func bottomView() -> some View {
        VStack(spacing: 6) {
            AccentButton(text: "Разрешить") {
                NotificationManager.shared.requestAuthorization(callback: action)
            }

            TextButton(text: "Возможно позже") {
                delay(0.15) {
                    hasSkippedNotificationRequest = true
                    action()
                }
            }
        }
    }
}

#Preview {
    NotificationRequestView { }
}
