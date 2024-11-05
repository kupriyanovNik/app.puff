//
//  OnboardingWelcomeScreen.swift
//  Puff
//
//  Created by Никита Куприянов on 19.09.2024.
//

import SwiftUI

struct OnboardingWelcomeScreen: View {

    @ObservedObject var onboardingVM: OnboardingViewModel

    @State private var imageScale: CGFloat = 3

    @State private var shouldShow: Bool = false

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 24) {
                Image(.appIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(72)
                    .scaleEffect(imageScale)
                    .animation(.smooth, value: imageScale)
                    .onTapGesture(count: 5) {
                        onboardingVM.hasSeenOnboarding = true
                    }

                VStack(spacing: 12) {
                    if shouldShow {
                        Text("OnboardingWelcomeScreen.Congratulations")
                            .font(.bold28)
                            .foregroundStyle(Palette.textPrimary)
                            .transition(
                                .opacity.animation(.smooth.delay(0.25))
                            )
                    }

                    if shouldShow {
                        MarkdownText(
                            text: "OnboardingWelcomeScreen.RightPath".l,
                            markdowns: ["Вы на верном пути -", "You're on the right path -"]
                        )
                        .font(.semibold22)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                        .transition(
                            .opacity.animation(.smooth.delay(0.4))
                        )
                    }
                }
            }

            Spacer()

            if shouldShow {
                AccentButton(text: "Start".l, action: onboardingVM.nextScreen)
                    .transition(
                        .opacity.animation(.smooth.delay(0.55))
                    )
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .onAppear {
            delay(0.8) {
                imageScale = 1
            }

            delay(0.8) {
                animated {
                    shouldShow = true
                }
            }
        }
        .prepareForStackPresentation()
    }
}

#Preview {
    OnboardingWelcomeScreen(onboardingVM: .init())
}
