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
    @State private var shouldShowSubscriptionInfo: Bool = false

    @State private var offset: Double = .zero

    @Environment(\.scenePhase) var scenePhase
    @Environment(\.locale) var locale

    private var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                self.offset = max(0, value.translation.height / 30)
            }
            .onEnded { value in
                if value.translation.height > 15 {
                    navigationVM.shouldShowAccountView = false

                    delay(0.3) {
                        offset = .zero
                    }
                } else {
                    offset = .zero
                }
            }
    }

    private var communityUrlString: String {
        if locale == .init(languageCode: "ru") {
            return "https://t.me/puffless_app_ru"
        }

        return "https://t.me/puffless_app"
    }

    var body: some View {
        CircledTopCornersView(background: .clear, content: viewContent)
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
            .offset(y: min(15, offset))
            .animation(.easeOut(duration: 0.25), value: offset)
            .overlay {
                Group {
                    if shouldShowSubscriptionInfo {
                        AccountViewSubscriptionInfoView(subscriptionsManager: subscriptionsManager) {
                            shouldShowSubscriptionInfo = false
                        }
                        .preferredColorScheme(.light)
                        .transition(
                            .opacity.combined(with: .offset(y: 50))
                                .animation(.easeInOut(duration: 0.3))
                        )
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: shouldShowSubscriptionInfo)
            }
    }

    @ViewBuilder
    private func viewContent() -> some View {
        VStack(spacing: 28) {
            headerView()

            cells()

            Spacer()
        }
        .contentShape(.rect)
        .simultaneousGesture(gesture)
        .makeCustomSheet(isPresented: $shouldShowResetWarning, content: resetWarning)
    }

    @ViewBuilder
    private func headerView() -> some View {
        HStack(spacing: 8) {
            Button {
                navigationVM.shouldShowAccountView = false
            } label: {
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
                "Account.ContactUs".l,
                imageName: "accountTgImage"
            ) { "https://t.me/puffless_support".openURL() }

            cell(
                "Account.Subscription".l,
                imageName: "accountSubscriptionImage"
            ) {
                if subscriptionsManager.isPremium {
                    shouldShowSubscriptionInfo = true
                } else {
                    navigationVM.shouldShowPaywall = true
                }
            }

            cell(
                "Account.OurChannel".l,
                imageName: "accountLanguageImage"
            ) { communityUrlString.openURL() }

            cell(
                "Account.Notifications".l,
                imageName: "accountNotificationsImage",
                content: Toggle("", isOn: $isNotificationsEnabled).labelsHidden()
            ) { isNotificationsEnabled.toggle() }

            if smokesManager.isPlanStarted && !smokesManager.isPlanEnded {
                cell(
                    "Account.ResetQuittingPlan".l,
                    imageName: "accountResetImage",
                    withDivider: false,
                    color: Color(hex: 0xFF7D7D)
                ) { shouldShowResetWarning.toggle() }
            }
        }
        .roundedCornerWithBorder(lineWidth: 1, borderColor: Color(hex: 0xF0F0F0), radius: 16, corners: .allCorners)
        .padding(.horizontal, 12)
        .onChange(of: isNotificationsEnabled) { newValue in
            if newValue {
                requestNotifications()
            } else {
                NotificationManager.shared.removeAllNotifications()
            }
        }
    }

    @ViewBuilder
    private func resetWarning() -> some View {
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

                    delay(0.4) {
                        navigationVM.shouldShowAccountView = false
                    }
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

    private func checkNotifications() {
        NotificationManager.shared.checkNotificationStatus()

        isNotificationsEnabled = NotificationManager.shared.isNotificationEnabled
    }

    private func requestNotifications() {
        if NotificationManager.shared.isNotificationEnabled {
            NotificationManager.shared.scheduleNotifications(
                limits: Array(smokesManager.planLimits[smokesManager.currentDayIndex...])
            )
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
        smokesManager: .init(),
        subscriptionsManager: .init()
    )
}
