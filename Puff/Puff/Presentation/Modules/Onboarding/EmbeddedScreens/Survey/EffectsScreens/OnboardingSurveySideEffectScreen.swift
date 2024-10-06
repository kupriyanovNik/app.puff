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

    private let items: [(name: String, image: String)] = (1...5).map {
        (name: "OnboardingSurveySideEffects.Answer\($0)".l, image: "onboardingSideEffect\($0)Image")
    }

    var body: some View {
        OnboardingEffectsBaseScreen(
            text: "OnboardingSurveySideEffects.Title".l,
            markdowns: ["побочные эффекты", "side effects"],
            nextButtonText: "OnboardingSurveySideEffects.GetTheQuitPlan".l,
            items: items
        ) {
            delay(0.02) {
                onboardingVM.nextScreen()
            }
        } actionWithoutDelay: {
            isForwardDirection = true
        }
    }
}
