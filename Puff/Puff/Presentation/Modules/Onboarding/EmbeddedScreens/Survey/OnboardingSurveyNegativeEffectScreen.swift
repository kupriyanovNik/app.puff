//
//  OnboardingSurveyNegativeEffectScreen.swift
//  Puff
//
//  Created by Никита Куприянов on 20.09.2024.
//

import SwiftUI

struct OnboardingSurveyNegativeEffectScreen: View {

    @ObservedObject var onboardingVM: OnboardingViewModel

    @State var selectedIndices: [Int] = []

    private let items: [(name: String, image: String)] = [
        (name: "Кашель", image: "onboardingNegative1Image"),
        (name: "Раздражение в горле", image: "onboardingNegative2Image"),
        (name: "Одышка", image: "onboardingNegative3Image"),
        (name: "Головные боли/головокружение", image: "onboardingNegative4Image"),
        (name: "Повышенная утомляемость", image: "onboardingNegative5Image"),
        (name: "Тошнота", image: "onboardingNegative6Image")
    ]

    var body: some View {
        VStack(spacing: 20) {
            MarkdownText(
                text: "На что в вашей жизни парение оказывает негативный эффект?",
                markdown: "негативный эффект?"
            )
            .font(.bold28)
            .multilineTextAlignment(.center)

            picker()

            Spacer()

            AccentButton(text: "Далее", isDisabled: selectedIndices.isEmpty) {
                onboardingVM.nextScreen()
            }
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

#Preview {
    OnboardingSurveyNegativeEffectScreen(onboardingVM: .init())
}
