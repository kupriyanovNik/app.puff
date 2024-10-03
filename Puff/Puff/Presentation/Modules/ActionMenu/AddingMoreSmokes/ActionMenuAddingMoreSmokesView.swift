//
//  ActionMenuAddingMoreSmokesView.swift
//  Puff
//
//  Created by Никита Куприянов on 26.09.2024.
//

import SwiftUI

struct ActionMenuAddingMoreSmokesView: View {

    var onAddedMoreSmokes: (Int) -> Void
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 4) {
                Image(.actionMenuAddMoreSmokes)
                    .resizable()
                    .scaledToFit()
                    .frame(68)

                MarkdownText(
                    text: "Кажется, мы немного ошиблись со стартовым лимитом затяжек",
                    markdowns: ["немного ошиблись"]
                )
                .font(.bold22)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

                Text("Хотите добавить к сегодняшнему лимиту еще немного затяжек, чтобы начать бросать с этого числа?\n\nЭтот вопрос задаем только сегодня, на старте вашего пути :)")
                    .font(.medium16)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Palette.textSecondary)
                    .padding(.horizontal, 24)
                    .padding(.top, 14)
            }

            buttons()
        }
        .padding(.top, 5)
    }

    @ViewBuilder
    private func buttons() -> some View {
        VStack(spacing: 10) {
            AccentButton(text: "Нет! Это была последняя!", action: onDismiss)

            HStack(spacing: 10) {
                SecondaryButton(text: "+10", foreground: Palette.textSecondary) {
                    onAddedMoreSmokes(10)
                    onDismiss()
                }

                SecondaryButton(text: "+50", foreground: Palette.textSecondary) {
                    onAddedMoreSmokes(50)
                    onDismiss()
                }

                SecondaryButton(text: "+100", foreground: Palette.textSecondary) {
                    onAddedMoreSmokes(100)
                    onDismiss()
                }
            }
        }
        .padding(.bottom, 16)
        .padding(.horizontal, 12)
    }
}

#Preview {
    ActionMenuAddingMoreSmokesView { _ in

    } onDismiss: {

    }
}
