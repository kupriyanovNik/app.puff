//
//  OnboardingContractView.swift
//  Puff
//
//  Created by Никита Куприянов on 21.09.2024.
//

import SwiftUI
import CoreHaptics

struct OnboardingContractScreen: View {

    @ObservedObject var onboardingVM: OnboardingViewModel

    @State private var isPressing: Bool = false
    @State private var scaleEffect: Double = 1

    @State private var isPressingEnded: Bool = false

    var body: some View {
        VStack(spacing: 70) {
            MarkdownText(
                text: "Я верю, что у меня всё получится и что уже скоро я брошу парить!",
                markdowns: ["верю", "брошу парить!"]
            )
            .font(.bold22)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 10)

            VStack(spacing: 23) {
                touchidButton()
                    .onLongPressGesture(minimumDuration: 4, maximumDistance: 50) {
                        isPressingEnded = true
                        HapticManager.feedback(style: .heavy)
                    } onPressingChanged: { isPressed in
                        withAnimation {
                            isPressing = isPressed
                        }

                        if isPressed {
                            withAnimation(.linear(duration: 5)) {
                                scaleEffect = 10
                            }
                        }

                        if !isPressed && !isPressingEnded {
                            withAnimation {
                                scaleEffect = 1
                            }
                        }
                    }

                Text("Удерживайте, чтобы\nподтвердить")
                    .font(.medium16)
                    .foregroundStyle(Palette.textTertiary)
                    .lineLimit(2, reservesSpace: true)
                    .multilineTextAlignment(.center)
                    .opacity(isPressingEnded ? 0 : isPressing ? 0 : 1)
                    .animation(.smooth, value: isPressing)
            }
        }
        .padding(.horizontal, 20)
        .overlay {
            if isPressing || isPressingEnded {
                Text(isPressingEnded ? "Добро пожаловать в\nPuffless!" : "Продолжайте\nудерживать!")
                    .font(.bold22)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .offset(y: -50)
                    .id(isPressingEnded ? "A" : "B")
                    .transition(
                        .asymmetric(
                            insertion: .opacity.animation(.smooth.delay(0.3)),
                            removal: .opacity.animation(.smooth)
                        )
                    )
            }
        }
        .prepareForStackPresentationInOnboarding()
        .onChange(of: isPressingEnded) { newValue in
            if newValue {
                delay(2) {
                    onboardingVM.nextScreen()
                }
            }
        }
    }

    @ViewBuilder
    private func touchidButton() -> some View {
        Circle()
            .fill(Color(hex: 0x75B8FD))
            .frame(140)
            .scaleEffect(isPressingEnded ? 10 : scaleEffect)
            .background {
                Circle()
                    .stroke(
                        Color(hex: 0x007AFF, alpha: 0.24),
                        style: .init(lineWidth: 20)
                    )
            }
            .overlay {
                Image(.onboardingTouchID)
                    .resizable()
                    .scaledToFit()
                    .frame(72)
            }
    }
}

#Preview {
    OnboardingContractScreen(onboardingVM: .init())
}
