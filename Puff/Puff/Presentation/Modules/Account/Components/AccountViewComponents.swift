//
//  AccountViewComponents.swift
//  Puff
//
//  Created by Никита Куприянов on 04.10.2024.
//

import SwiftUI
import StoreKit

extension AccountView {
    struct AccountViewSubscriptionInfoView: View {

        @ObservedObject var subscriptionsManager: SubscriptionsManager

        @State private var shouldShowSubscriptionEndingView: Bool = false

        var backAction: () -> Void

        private let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.YYYY"

            return formatter
        }()

        private var subscriptionTypeText: String {
            if subscriptionsManager.withTrial {
                return "AccountSubscription.SubscriptionTypeMonthlyWithTrial".l
            }

            return "AccountSubscription.SubscriptionTypeMonthly".l
        }

        var body: some View {
            CustomDismissableView(dismissAction: backAction, content: viewContent)
                .makeCustomSheet(isPresented: $shouldShowSubscriptionEndingView) {
                    ActionMenuSubscriptionLeavingView { reasonsIndices, improvementsText in
                        requestCancel()
                    } onDismiss: {
                        shouldShowSubscriptionEndingView = false
                    }
                }
        }

        @ViewBuilder
        private func viewContent() -> some View {
            VStack(spacing: 28) {
                headerView()

                if let transaction = subscriptionsManager.activeTransactions.first {
                    cell(
                        title: "AccountSubscription.SubscriptionType".l,
                        subtitle: subscriptionTypeText
                    )

                    cell(
                        title: "AccountSubscription.StartDate".l,
                        subtitle: formatter.string(from: transaction.originalPurchaseDate)
                    )

                    if let expirationDate = transaction.expirationDate {
                        cell(
                            title: "AccountSubscription.BillingDate".l,
                            subtitle: formatter.string(from: expirationDate)
                        )
                    }
                }

                Spacer()

                TextButton(text: "AccountSubscription.CancelSubscription".l) {
                    shouldShowSubscriptionEndingView = true
                }
                .padding(.bottom, isSmallDevice ? 16 : 0)
            }
            .padding(.horizontal, 28)
        }

        @ViewBuilder
        private func headerView() -> some View {
            HStack(spacing: 8) {
                Button {
                    backAction()
                } label: {
                    Image(.accountBack)
                        .resizable()
                        .scaledToFit()
                        .frame(26)
                }

                Text("Account.Subscription".l)
                    .font(.semibold22)
                    .foregroundStyle(Palette.textPrimary)

                Spacer()
            }
            .padding(.top, 22)
            .padding(.leading, -12)
        }

        @ViewBuilder
        private func cell(title: String, subtitle: String) -> some View {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.medium15)
                        .foregroundStyle(Palette.textSecondary)

                    Text(subtitle)
                        .font(.medium16)
                        .foregroundStyle(Palette.textPrimary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()
            }
        }

        private func requestCancel() {
            if let scene = UIApplication.shared
                .connectedScenes
                .first(
                    where: { $0.activationState == .foregroundActive }
                ) as? UIWindowScene {

                Task {
                    try await AppStore.showManageSubscriptions(in: scene)
                }
            }
        }
    }
}
