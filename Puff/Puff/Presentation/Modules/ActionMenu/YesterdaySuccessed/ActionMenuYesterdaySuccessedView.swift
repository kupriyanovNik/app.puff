//
//  ActionMenuYesterdaySuccessedView.swift
//  Puff
//
//  Created by Никита Куприянов on 06.11.2024.
//

import SwiftUI

struct ActionMenuYesterdaySuccessedView: View {

    var todayLimit: Int
    var onDismiss: () -> Void

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

                Text(
                    "Сегодняшний лимит - {count} затяжек.".formatByDivider(
                        divider: "{count}",
                        count: todayLimit
                    )
                )
                .font(.semibold16)
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
    ActionMenuYesterdaySuccessedView(todayLimit: 333) { }
}
