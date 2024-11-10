//
//  AccountViewComponents.swift
//  Puff
//
//  Created by Никита Куприянов on 04.10.2024.
//

import SwiftUI
import StoreKit
import Adapty

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

        @State private var paymentText: String = ""

        var body: some View {
            CircledTopCornersView(background: .init(hex: 0xF5F5F5), content: viewContent)
                .makeCustomSheet(isPresented: $shouldShowSubscriptionEndingView) {
                    ActionMenuSubscriptionLeavingView { reasonsIndices, improvementsText in
                        requestCancel()
                    } onDismiss: {
                        shouldShowSubscriptionEndingView = false
                    }
                }
                .task { await subscriptionsManager.fetchActiveTransactions() }
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
                            title: paymentText,
                            subtitle: formatter.string(from: expirationDate)
                        )
                    }
                }

                Spacer()

                TextButton(text: "AccountSubscription.CancelSubscription".l) {
                    shouldShowSubscriptionEndingView = true
                }
                .padding(.bottom, isSmallDevice ? 16 : 7)
            }
            .padding(.horizontal, 28)
            .onAppear(perform: setText)
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
            .padding(.top, 10)
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

        private func setText() {
            guard let transaction = subscriptionsManager.activeTransactions.first,
                  let endDate = transaction.expirationDate else {
                self.paymentText = "AccountSubscription.BillingDate".l
                return
            }

            let diff = endDate - transaction.originalPurchaseDate

            if diff <= TimeInterval(260000) {
                self.paymentText = "AccountSubscription.EndOfTrial".l
            } else {
                self.paymentText = "AccountSubscription.BillingDate".l
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
