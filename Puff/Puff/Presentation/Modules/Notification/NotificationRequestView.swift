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

            LottieView(name: "NotificationRequestAnimation", loopMode: .loop, delay: 0.2)
                .scaledToFit()
                .padding(.horizontal, 60)

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
            .offset(y: -50)

            Spacer()

            bottomView()
        }
        .padding(.horizontal, 20)
        .prepareForStackPresentationInOnboarding()
    }

    @ViewBuilder
    private func bottomView() -> some View {
        VStack(spacing: 6) {
            AccentButton(text: "Разрешить") {
                NotificationManager.shared.requestAuthorization {
                    NotificationManager.shared.sendFirstDayNotification()
                    action()
                }
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
