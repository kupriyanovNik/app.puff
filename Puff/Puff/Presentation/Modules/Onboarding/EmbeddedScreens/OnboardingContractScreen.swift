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

    @State private var engine: CHHapticEngine?

    var body: some View {
        VStack(spacing: 70) {
            MarkdownText(
                text: "OnboardingContractScreen.Title".l,
                markdowns: ["верю", "брошу парить!", "determined", "I will succeed!"]
            )
            .font(.bold22)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 10)

            VStack(spacing: 23) {
                touchidButton()
                    .onLongPressGesture(minimumDuration: 3.75, maximumDistance: 50) {
                        isPressingEnded = true
                        haptics()
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

                Text("OnboardingContractScreen.HoldToConfirm".l)
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
                Text(
                    isPressingEnded ? "OnboardingContractScreen.Welcome".l : "OnboardingContractScreen.KeepHolding".l
                )
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
        .onAppear(perform: prepareHaptics)
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

    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }

    func haptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }

        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}

#Preview {
    OnboardingContractScreen(onboardingVM: .init())
}
