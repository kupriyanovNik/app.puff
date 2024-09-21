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
        LazyVGrid(columns: [.init(.flexible()), .init(.flexible())]) {
            ForEach(items.indices) { index in
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
        .padding(.horizontal, 12)
    }
}
