//
//  OnboardingWelcomeScreen.swift
//  Puff
//
//  Created by Никита Куприянов on 19.09.2024.
//

import SwiftUI

struct OnboardingWelcomeScreen: View {

    @ObservedObject var onboardingVM: OnboardingViewModel

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 24) {
                Image(.appIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(72)
                    .onTapGesture(count: 5) {
                        onboardingVM.hasSeenOnboarding = true
                    }

                VStack(spacing: 12) {
                    Text("OnboardingWelcomeScreen.Congratulations")
                        .font(.bold28)
                        .foregroundStyle(Palette.textPrimary)

                    MarkdownText(
                        text: "OnboardingWelcomeScreen.RightPath".l,
                        markdowns: ["Вы на верном пути -", "You're on the right path -"]
                    )
                    .font(.semibold22)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                }
            }

            Spacer()

            AccentButton(text: "Start".l, action: onboardingVM.nextScreen)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .prepareForStackPresentation()
    }
}

#Preview {
    OnboardingWelcomeScreen(onboardingVM: .init())
}
