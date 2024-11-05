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
                text: "OnboardingSurvey.Description".l,
                markdowns: ["8 быстрых вопросов,", "8 quick questions"]
            )
            .font(.bold22)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 8)

            Spacer()

            AccentButton(text: "Next".l, action: onboardingVM.nextScreen)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .prepareForStackPresentation()
    }
}

#Preview {
    OnboardingSurveyDescriptionScreen(onboardingVM: .init())
}
