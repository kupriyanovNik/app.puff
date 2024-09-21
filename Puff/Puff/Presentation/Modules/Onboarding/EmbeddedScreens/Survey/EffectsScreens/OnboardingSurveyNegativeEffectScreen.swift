//
//  OnboardingSurveyNegativeEffectScreen.swift
//  Puff
//
//  Created by Никита Куприянов on 20.09.2024.
//

import SwiftUI

struct OnboardingSurveyNegativeEffectScreen: View {

    @ObservedObject var onboardingVM: OnboardingViewModel

    private let items: [(name: String, image: String)] = [
        (name: "Здоровье, самочувствие", image: "onboardingNegativeEffect1Image"),
        (name: "Эмоциональное состояние", image: "onboardingNegativeEffect2Image"),
        (name: "Отношения с близкими", image: "onboardingNegativeEffect3Image"),
        (name: "Финансы", image: "onboardingNegativeEffect4Image")
    ]

    var body: some View {
        OnboardingEffectsBaseScreen(
            text: "На что в вашей жизни парение оказывает негативный эффект?",
            markdown: "негативный эффект?",
            nextButtonText: "Далее",
            items: items
        ) {
            onboardingVM.questionIndex += 1
        }
    }
}
