//
//  OnboardingEffectsBaseScreen.swift
//  Puff
//
//  Created by Никита Куприянов on 21.09.2024.
//

import SwiftUI

struct OnboardingEffectsBaseScreen: View {

    @State var selectedIndices: [Int] = []

    let text: String
    let markdown: String
    let items: [(name: String, image: String)]

    var action: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            MarkdownText(
                text: text,
                markdown: markdown
            )
            .font(.bold28)
            .multilineTextAlignment(.center)

            picker()

            Spacer()

            AccentButton(text: "Далее", isDisabled: selectedIndices.isEmpty, action: action)
                .padding(.horizontal, 20)
                .padding(.bottom, -16)
        }
    }

    @ViewBuilder
    private func picker() -> some View {
        // нельзя использовать LazyVGrid потому что ios < 17 багованная анимация
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                ForEach(0..<2, content: cardView)
            }

            HStack(spacing: 10) {
                ForEach(2..<4, content: cardView)
            }

            if items.count == 6 {
                HStack(spacing: 10) {
                    ForEach(4..<6, content: cardView)
                }
            }
        }
        .padding(.horizontal, 12)
    }

    @ViewBuilder
    private func cardView(_ index: Int) -> some View {
        let item = items[index]

        PickerCard(
            title: item.name,
            imageName: item.image,
            isSelected: selectedIndices.contains(index)
        ) {
            if let index = selectedIndices.firstIndex(of: index) {
                selectedIndices.remove(at: index)
            } else {
                selectedIndices.append(index)
            }
        }
        .animation(.smooth, value: selectedIndices)
    }
}
