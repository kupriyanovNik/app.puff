//
//  NotificationRequestView.swift
//  Puff
//
//  Created by Никита Куприянов on 22.09.2024.
//

import SwiftUI

struct NotificationRequestView: View {

    @AppStorage("hasSkippedNotificationRequest") var hasSkippedNotificationRequest: Bool = false

    var action: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            LottieView(name: "NotificationRequestAnimation", loopMode: .loop, delay: 0.2)
                .scaledToFit()
                .padding(.horizontal, 60)

            VStack(spacing: 16) {
                Text("NotificationRequest.Title".l)
                    .font(.bold28)
                    .foregroundStyle(Palette.textPrimary)

                Text("NotificationRequest.Description".l)
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
            AccentButton(text: "Allow".l) {
                NotificationManager.shared.requestAuthorization {
                    NotificationManager.shared.sendFirstDaysNotifications()
                    action()
                }
            }

            TextButton(text: "NotificationRequest.MaybeLater".l) {
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
