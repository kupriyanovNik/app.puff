//
//  AccountView.swift
//  Puff
//
//  Created by Никита Куприянов on 28.09.2024.
//

import SwiftUI

struct AccountView: View {

    @ObservedObject var navigationVM: NavigationViewModel
    @ObservedObject var smokesManager: SmokesManager

    @State private var isNotificationsEnabled: Bool = NotificationManager.shared.isNotificationEnabled
    @AppStorage("hasSkippedNotificationRequest") var hasSkippedNotificationRequest: Bool = true

    @State private var shouldShowResetWarning: Bool = false

    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        CircledTopCornersView(content: viewContent)
            .onChange(of: scenePhase) { newValue in
                if newValue == .active {
                    isNotificationsEnabled = NotificationManager.shared.isNotificationEnabled
                }
            }
            .onAppear {
                delay(0.6) {
                    isNotificationsEnabled = NotificationManager.shared.isNotificationEnabled
                }
            }
    }

    @ViewBuilder
    private func viewContent() -> some View {
        VStack(spacing: 28) {
            headerView()

            cells()

            Spacer()
        }
        .makeCustomSheet(isPresented: $shouldShowResetWarning, content: resetWarning)
    }

    @ViewBuilder
    private func headerView() -> some View {
        HStack(spacing: 8) {
            Button {
                navigationVM.shouldShowAccountView.toggle()
            } label: {
                Image(.accountBack)
                    .resizable()
                    .scaledToFit()
                    .frame(26)
            }

            Text("Настройки")
                .font(.semibold22)
                .foregroundStyle(Palette.textPrimary)

            Spacer()
        }
        .padding(.top, 22)
        .padding(.leading, 16)
    }

    @ViewBuilder
    private func cell<Content: View>(
        _ text: String,
        imageName: String,
        withDivider: Bool = true,
        color: Color = Palette.textPrimary,
        content: Content = Image(.accountBack).resizable().scaledToFit().frame(22).rotationEffect(.degrees(180)),
        action: @escaping () -> Void = {}
    ) -> some View {
        HStack(spacing: 10) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(28)

            Text(text)
                .font(.semibold16)
                .foregroundStyle(color)

            Spacer()

            content
        }
        .padding(.vertical, 13)
        .padding(.trailing, 14)
        .padding(.leading, 10)
        .overlay(alignment: .bottom) {
            if withDivider {
                Rectangle()
                    .fill(Color(hex: 0xF0F0F0))
                    .height(1)
                    .padding(.leading, 48)
            }
        }
        .contentShape(.rect)
        .onTapGesture(perform: action)
    }

    @ViewBuilder
    private func cells() -> some View {
        VStack(spacing: 0) {
//            cell("Виджеты", imageName: "accountWidgetsImage")

            cell(
                "Связаться с нами",
                imageName: "accountTgImage"
            ) { "OUR TELEGRAM".openURL() }

            cell(
                "Подписка",
                imageName: "accountSubscriptionImage"
            )

            cell(
                "Сменить язык",
                imageName: "accountLanguageImage"
            ) { UIApplication.openSettingsURLString.openURL() }

            cell(
                "Уведомления",
                imageName: "accountNotificationsImage",
                content: Toggle("", isOn: $isNotificationsEnabled).labelsHidden()
            ) { isNotificationsEnabled.toggle() }

            cell(
                "Сбросить план бросания",
                imageName: "accountResetImage",
                withDivider: false,
                color: Color(hex: 0xFF7D7D)
            ) { shouldShowResetWarning.toggle() }
        }
        .roundedCornerWithBorder(lineWidth: 1, borderColor: Color(hex: 0xF0F0F0), radius: 16, corners: .allCorners)
        .padding(.horizontal, 12)
        .onChange(of: isNotificationsEnabled) { newValue in
            handleChangeOfNotificationStatus(newValue)
        }
    }

    @ViewBuilder
    private func resetWarning() -> some View {
        VStack(spacing: 32) {
            VStack(spacing: 18) {
                MarkdownText(
                    text: "Вы уверены, что хотите сбросить план бросания?",
                    markdowns: ["сбросить план бросания?"],
                    accentColor: Color(hex: 0xFF7D7D)
                )
                .font(.bold22)
                .multilineTextAlignment(.center)

                Text("Это не затронет статистику затяжек - все данные о том, сколько вы парили ранее, сохранятся.\n\nВ любое время вы сможете заново начать любой план бросания.")
                    .font(.medium16)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Palette.textSecondary)
            }
            .padding(.horizontal, 24)

            VStack(spacing: 10) {
                AccentButton(text: "Да, сбросить план", background: Color(hex: 0xFF7D7D)) {
                    smokesManager.resetPlan()
                    shouldShowResetWarning = false
                }

                SecondaryButton(text: "Отмена") {
                    shouldShowResetWarning = false
                }
            }
            .padding(.horizontal, 12)
        }
        .padding(.bottom, 16)
        .padding(.top, 20)
    }

    private func handleChangeOfNotificationStatus(_ value: Bool) {
        if !value {
            NotificationManager.shared.removeAllNotifications()
            return
        }

        if hasSkippedNotificationRequest {
            NotificationManager.shared.requestAuthorization()
        } else {
            UIApplication.openNotificationSettingsURLString.openURL()
        }
    }
}

#Preview {
    AccountView(
        navigationVM: .init(),
        smokesManager: .init()
    )
}
