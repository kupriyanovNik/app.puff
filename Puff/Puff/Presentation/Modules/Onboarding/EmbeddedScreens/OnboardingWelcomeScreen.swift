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

                VStack(spacing: 12) {
                    if shouldShow {
                        Text("Поздравляем!")
                            .font(.bold28)
                            .foregroundStyle(Palette.textPrimary)
                            .transition(
                                .opacity.animation(.smooth.delay(0.25))
                            )
                    }

                    if shouldShow {
                        MarkdownText(
                            text: "Вы на верном пути - скоро привычка парить останется в прошлом!",
                            markdown: "Вы на верном пути -"
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
                AccentButton(text: "Начать", action: onboardingVM.nextScreen)
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
        .prepareForStackPresentationInOnboarding()
    }
}

#Preview {
    OnboardingWelcomeScreen(onboardingVM: .init())
}
