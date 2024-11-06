//
//  ActionMenuYesterdaySuccessedView.swift
//  Puff
//
//  Created by Никита Куприянов on 06.11.2024.
//

import SwiftUI

struct ActionMenuYesterdaySuccessedView: View {

    var daysToEnd: Int
    var todayLimit: Int
    var onDismiss: () -> Void

    private var text: String {
        var firstPart: String = ""

        if daysToEnd == 0 {
            firstPart = "ActionMenuYesterdaySuccessed.LastDay".l
        } else if daysToEnd == 1 {
            firstPart = "ActionMenuYesterdaySuccessed.1DayLeast".l
        } else {
            firstPart = "ActionMenuYesterdaySuccessed.3DaysLeast".l
        }

        let secondPart = "ActionMenuYesterdaySuccessed.Description".l.formatByDivider(
            divider: "{count}",
            count: todayLimit
        )

        return [0, 1, 3].contains(daysToEnd) ? (firstPart + secondPart) : secondPart
    }

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 18) {
                LottieView(name: "ActionMenuReadyToBreakReadyAnimation", loopMode: .loop, delay: 0.3)
                    .frame(68)
                    .padding(.bottom, -14)

                MarkdownText(
                    text: "ActionMenuYesterdaySuccessed.Title".l,
                    markdowns: ["Так держать!", "Keep it up!"],
                    accentColor: .init(hex: 0xFABC18)
                )
                .font(.bold22)
                .multilineTextAlignment(.center)

                Text(text)
                    .font(.semibold16)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Palette.textSecondary)
            }
            .padding(.horizontal, 12)

            AccentButton(text: "Ok") {
                HapticManager.actionMenusButton()
                onDismiss()
            }
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 16)
        .padding(.top, 20)
    }
}

#Preview {
    ActionMenuYesterdaySuccessedView(daysToEnd: 5, todayLimit: 333) { }
}
