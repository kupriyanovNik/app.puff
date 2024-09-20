//
//  OnboardingSurveyDescriptionScreen.swift
//  Puff
//
//  Created by Никита Куприянов on 20.09.2024.
//

import SwiftUI

struct OnboardingSurveyDescriptionScreen: View {

    @ObservedObject var onboardingVM: OnboardingViewModel

    var body: some View {
        VStack(spacing: 12) {
            Spacer()

            Image(.onboardingSurvey)
                .resizable()
                .scaledToFit()
                .frame(64)

            MarkdownText(
                text: "Теперь - всего 8 быстрых вопросов, чтобы мы смогли подобрать вам оптимальный план бросания!",
                markdown: "8 быстрых вопросов,"
            )
            .font(.bold22)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 8)

            Spacer()

            AccentButton(text: "Далее", action: onboardingVM.nextScreen)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .prepareForStackPresentationInOnboarding()
    }
}

#Preview {
    OnboardingSurveyDescriptionScreen(onboardingVM: .init())
}
