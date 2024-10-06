//
//  OnboardingSurveySideEffectScreen.swift
//  Puff
//
//  Created by Никита Куприянов on 21.09.2024.
//

import SwiftUI

struct OnboardingSurveySideEffectScreen: View {

    @ObservedObject var onboardingVM: OnboardingViewModel
    @Binding var isForwardDirection: Bool

    @State var selectedIndices: [Int] = []

    private let items: [(name: String, image: String)] = [
        (name: "Кашель", image: "onboardingSideEffect1Image"),
        (name: "Раздражение в горле", image: "onboardingSideEffect2Image"),
        (name: "Одышка", image: "onboardingSideEffect3Image"),
        (name: "Головные боли/головокружение", image: "onboardingSideEffect4Image"),
        (name: "Повышенная утомляемость", image: "onboardingSideEffect5Image"),
        (name: "Тошнота", image: "onboardingSideEffect6Image")
    ]

    var body: some View {
        OnboardingEffectsBaseScreen(
            text: "Какие побочные эффекты от парения вы замечаете?",
            markdown: "побочные эффекты",
            nextButtonText: "Определить план бросания",
            items: items
        ) {
            onboardingVM.nextScreen()
        } actionWithoutDelay: {
            isForwardDirection = true
        }
    }
}
