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
            firstPart = "Сегодня - последний день плана!\n"
        } else if daysToEnd == 1 {
            firstPart = "До конца плана остался всего 1 день!\n"
        } else {
            firstPart = "До конца плана осталось всего 3 дня!\n"
        }

        let secondPart = "Сегодняшний лимит - {count} затяжек.".formatByDivider(
            divider: "{count}",
            count: todayLimit
        )

        return [0, 1, 3].contains(daysToEnd) ? (firstPart + secondPart) : secondPart
    }

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 18) {
                Image(.actionMenuBroke)
                    .resizable()
                    .scaledToFit()
                    .frame(68)
                    .padding(.bottom, -14)

                MarkdownText(
                    text: "Вы справились со вчерашним лимитом.\nТак держать!",
                    markdowns: ["Так держать!"],
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

            AccentButton(text: "Ok", action: onDismiss)
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 16)
        .padding(.top, 20)
    }
}

#Preview {
    ActionMenuYesterdaySuccessedView(daysToEnd: 5, todayLimit: 333) { }
}
