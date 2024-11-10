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
    @ObservedObject var subscriptionsManager: SubscriptionsManager

    @AppStorage("isNotificationsEnabled") var isNotificationsEnabled: Bool = false
    @AppStorage("hasSkippedNotificationRequest") var hasSkippedNotificationRequest: Bool = false

    @State private var shouldShowResetWarning: Bool = false

    @Environment(\.scenePhase) var scenePhase
    @Environment(\.locale) var locale

    private var communityUrlString: String {
        if locale == .init(languageCode: "ru") {
            return "https://t.me/puffless_app_ru"
        }

        return "https://t.me/puffless_app"
    }

    var body: some View {
        CircledTopCornersView(background: .init(hex: 0xF5F5F5), content: viewContent)
            .onChange(of: scenePhase) { newValue in
                if newValue == .active {
                    checkNotifications()
                }
            }
            .onAppear {
                NotificationManager.shared.checkNotificationStatus()

                delay(0.6) {
                    checkNotifications()
                }
            }
            .overlay(alignment: .bottom) {
                Group {
                    if subscriptionsManager.isPremium {
                        TextButton(text: "Account.SubscriptionIsActive".l, action: navigationVM.showSubscriptionInfo)
                            .padding(.bottom, 7)
                    }
                }
            }
            .makeCustomSheet(isPresented: $shouldShowResetWarning) {
                Group {
                    if smokesManager.isPlanStarted {
                        resetWarningIfPlanStarted()
                    } else {
                        resetWarningIfPlanNotStarted()
                    }
                }
            }
    }

    @ViewBuilder
    private func viewContent() -> some View {
        VStack(spacing: 12) {
            headerView()

            cells()

            Spacer()
        }
    }

    @ViewBuilder
    private func headerView() -> some View {
        HStack(spacing: 8) {
            Button(action: navigationVM.back) {
                Image(.accountBack)
                    .resizable()
                    .scaledToFit()
                    .frame(26)
            }

            Text("Account.Title".l)
                .font(.semibold22)
                .foregroundStyle(Palette.textPrimary)

            Spacer()
        }
        .padding(.top, 10)
        .padding(.leading, 16)
    }

    @ViewBuilder
    private func cell<Content: View>(
        _ text: String,
        imageName: String,
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
        .padding(.trailing, 20)
        .padding(.leading, 13)
        .contentShape(.rect)
        .onTapGesture(perform: action)
    }

    @ViewBuilder
    private func cells() -> some View {
        VStack(spacing: 0) {
            if #available(iOS 17.0, *) {
                cell(
                    "Account.Widgets".l,
                    imageName: "accountWidgetsImage",
                    action: navigationVM.showWidgetsInfo
                )
            }

            cell(
                "Account.ContactUs".l,
                imageName: "accountTgImage"
            ) { "https://t.me/puffless_support".openURL() }

            cell(
                "Account.OurChannel".l,
                imageName: "accountLanguageImage"
            ) { "Account.OurChannel.Link".l.openURL() }

            cell(
                "Account.ChangeLanguage".l,
                imageName: "accountChangeLanguageImage"
            ) { UIApplication.openSettingsURLString.openURL() }

            cell(
                "Account.Notifications".l,
                imageName: "accountNotificationsImage",
                content: Toggle("", isOn: $isNotificationsEnabled).labelsHidden()
            ) { isNotificationsEnabled.toggle() }

            if smokesManager.smokesCount.reduce(0, +) > 0 {
                cell(
                    smokesManager.isPlanStarted ? "Account.ResetQuittingPlan".l : "Account.ResetAllSmokes".l,
                    imageName: "accountResetImage",
                    color: Color(hex: 0xFF7D7D)
                ) { shouldShowResetWarning.toggle() }
            }
        }
        .onChange(of: isNotificationsEnabled) { newValue in
            if newValue {
                requestNotifications()
            } else {
                NotificationManager.shared.removeAllNotifications()
            }
        }
    }

    private func checkNotifications() {
        if !isNotificationsEnabled {
            if hasSkippedNotificationRequest {
                isNotificationsEnabled = false
            } else {
                NotificationManager.shared.checkNotificationStatus()
                isNotificationsEnabled = NotificationManager.shared.isNotificationEnabled
            }
        } else {
            NotificationManager.shared.checkNotificationStatus()
            isNotificationsEnabled = NotificationManager.shared.isNotificationEnabled
        }
    }

    private func requestNotifications() {
        NotificationManager.shared.checkNotificationStatus()

        if !NotificationManager.shared.isNotificationEnabled {
            if hasSkippedNotificationRequest {
                NotificationManager.shared.requestAuthorization {
                    if smokesManager.isPlanStarted {
                        if NotificationManager.shared.isNotificationEnabled {
                            NotificationManager.shared.scheduleNotifications(
                                limits: Array(smokesManager.planLimits[smokesManager.currentDayIndex...])
                            )
                            return
                        }
                    } else {
                        if NotificationManager.shared.isNotificationEnabled {
                            NotificationManager.shared.scheduleNotifications(limits: [])
                            return
                        }
                    }
                }
            } else {
                UIApplication.openNotificationSettingsURLString.openURL()
            }
        }
    }
}

extension AccountView {
    @ViewBuilder func resetWarningIfPlanStarted() -> some View {
        VStack(spacing: 32) {
            VStack(spacing: 18) {
                MarkdownText(
                    text: "AccountPlanQuitting.Title".l,
                    markdowns: ["сбросить план бросания?", "reset your quit plan?"],
                    accentColor: Color(hex: 0xFF7D7D)
                )
                .font(.bold22)
                .multilineTextAlignment(.center)

                Text("AccountPlanQuitting.Description".l)
                    .font(.medium16)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Palette.textSecondary)
            }
            .padding(.horizontal, 24)

            VStack(spacing: 10) {
                AccentButton(text: "AccountPlanQuitting.Reset".l, background: Color(hex: 0xFF7D7D)) {
                    smokesManager.resetPlan()
                    shouldShowResetWarning = false
                    AnalyticsManager.logEvent(event: .resetedPlan)
                }

                SecondaryButton(text: "Cancel".l) {
                    shouldShowResetWarning = false
                }
            }
            .padding(.horizontal, 12)
        }
        .padding(.bottom, 16)
        .padding(.top, 20)
    }

    @ViewBuilder func resetWarningIfPlanNotStarted() -> some View {
        VStack(spacing: 32) {
            VStack(spacing: 18) {
                MarkdownText(
                    text: "AccountSmokesResetting.Title".l,
                    markdowns: ["сбросить все затяжки?", "reset all puffs?"],
                    accentColor: Color(hex: 0xFF7D7D)
                )
                .font(.bold22)
                .multilineTextAlignment(.center)

                Text("AccountSmokesResetting.Description".l)
                    .font(.medium16)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Palette.textSecondary)
            }
            .padding(.horizontal, 24)

            VStack(spacing: 10) {
                AccentButton(text: "AccountSmokesResetting.Reset".l, background: Color(hex: 0xFF7D7D)) {
                    smokesManager.resetAllSmokes()
                    shouldShowResetWarning = false
                    AnalyticsManager.logEvent(event: .resetedSmokes)
                }

                SecondaryButton(text: "Cancel".l) {
                    shouldShowResetWarning = false
                }
            }
            .padding(.horizontal, 12)
        }
        .padding(.bottom, 16)
        .padding(.top, 20)
    }
}
