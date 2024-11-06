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
                LottieView(name: "ActionMenuAddingMoreSmokesAnimation", delay: 0.3)
                    .frame(68)

                MarkdownText(
                    text: "ActionMenuAddingMoreSmokes.Title".l,
                    markdowns: ["немного ошиблись", "a bit wrong"]
                )
                .font(.bold22)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

                Text("ActionMenuAddingMoreSmokes.Description".l)
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
            AccentButton(text: "ActionMenuAddingMoreSmokes.NoItWasLast".l) {
                HapticManager.actionMenusButton()
                onDismiss()
            }

            HStack(spacing: 10) {
                SecondaryButton(text: "+10", foreground: Palette.textSecondary) {
                    onAddedMoreSmokes(10)
                    HapticManager.actionMenusButton()
                    onDismiss()
                }

                SecondaryButton(text: "+50", foreground: Palette.textSecondary) {
                    onAddedMoreSmokes(50)
                    HapticManager.actionMenusButton()
                    onDismiss()
                }

                SecondaryButton(text: "+100", foreground: Palette.textSecondary) {
                    onAddedMoreSmokes(100)
                    HapticManager.actionMenusButton()
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
