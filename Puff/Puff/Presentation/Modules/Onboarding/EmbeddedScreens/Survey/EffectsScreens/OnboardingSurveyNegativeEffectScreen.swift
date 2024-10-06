//
//  OnboardingSurveyNegativeEffectScreen.swift
//  Puff
//
//  Created by Никита Куприянов on 20.09.2024.
//

import SwiftUI

struct OnboardingSurveyNegativeEffectScreen: View {

    @ObservedObject var onboardingVM: OnboardingViewModel
    @Binding var isForwardDirection: Bool

    private let items: [(name: String, image: String)] = (1...4).map {
        (name: "OnboardingSurveyNegativeEffect.Answer\($0)".l, image: "onboardingNegativeEffect\($0)Image")
    }

    var body: some View {
        OnboardingEffectsBaseScreen(
            text: "OnboardingSurveyNegativeEffect.Title".l,
            markdowns: ["негативный эффект?", "negative effects"],
            nextButtonText: "Next".l,
            items: items
        ) {
            isForwardDirection = true
            
            delay(0.02) {
                onboardingVM.questionIndex = 8
            }
        }
    }
}
