//
//  ActionMenuSubscriptionLeavingInFirst3DaysView.swift
//  Puff
//
//  Created by Никита Куприянов on 13.11.2024.
//

import SwiftUI

struct ActionMenuSubscriptionLeavingInFirst3DaysView: View {

    var onCancelSubscription: () -> Void
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 22) {
            MarkdownText(
                text: "AccountSubscription.LeavingInFirst3Days.Title".l,
                markdowns: ["3 дня", "3 days"],
                accentColor: .init(hex: 0xFF7D7D)
            )
            .font(.bold26)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 8)

            HStack(spacing: 10) {
                cell(
                    imageName: "subscriptionLeavingInFirst3DaysCell1Image",
                    title: "85%",
                    description: "AccountSubscription.LeavingInFirst3Days.Description1".l
                )
                cell(
                    imageName: "subscriptionLeavingInFirst3DaysCell2Image",
                    title: "9x",
                    description: "AccountSubscription.LeavingInFirst3Days.Description2".l
                )
            }
            .padding(.bottom, 14)

            VStack(spacing: 6) {
                AccentButton(text: "AccountSubscription.Leaving.Cancel.StayPremium".l, action: onDismiss)

                TextButton(text: "AccountSubscription.Leaving.Cancel.CancelAnyway".l, action: onCancelSubscription)
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 12)
    }

    @ViewBuilder
    private func cell(
        imageName: String,
        title: String,
        description: String
    ) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .overlay(alignment: .top) {
                VStack(spacing: 2) {
                    Text(title)
                        .font(.bold46)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                        .foregroundStyle(Palette.darkBlue)

                    Text(description)
                        .font(.medium15)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.8)
                        .foregroundStyle(Palette.textTertiary)
                }
                .padding(.top, 15)
                .padding(.horizontal, 12)
            }
            .cornerRadius(16)
    }
}

#Preview {
    ActionMenuSubscriptionLeavingInFirst3DaysView {

    } onDismiss: {

    }
}
