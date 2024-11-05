//
//  OnboardingPlanCreatingScreen.swift
//  Puff
//
//  Created by Никита Куприянов on 21.09.2024.
//

import SwiftUI

struct OnboardingPlanCreatingScreen: View {

    @ObservedObject var onboardingVM: OnboardingViewModel

    @State private var loaderTrim: Double = 0
    @State private var showText: Bool = true

    @State private var shouldShowPlanScreen: Bool = false

    var body: some View {
        Group {
            if !shouldShowPlanScreen {
                VStack(spacing: 18) {
                    Spacer()

                    loaderView()

                    MarkdownText(
                        text: "OnboardingPlanCreating.Title".l,
                        markdowns: ["план бросания...", "the best quit plan"]
                    )
                    .font(.bold22)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .opacity(showText ? 1 : 0)
                    .offset(y: showText ? 0 : 35)
                    .animation(.easeInOut(duration: 0.35), value: showText)

                    Spacer()
                }
                .transition(.opacity.animation(.easeOut(duration: 0.2)))
            } else {
                OnboardingPlanScreen(onboardingVM: onboardingVM)
                    .transition(.opacity.animation(.easeOut(duration: 0.2).delay(0.3)))
            }
        }
        .prepareForStackPresentation()
        .onAppear {
            delay(0.5) {
                withAnimation(.linear(duration: 2.5)) {
                    loaderTrim = 1
                }
            }
        }
        .onAppear {
            delay(2.4) {
                showText.toggle()
            }
        }
        .onAppear {
            delay(3) {
                shouldShowPlanScreen.toggle()
            }
        }
    }

    @ViewBuilder
    private func loaderView() -> some View {
        Circle()
            .stroke(Color(hex: 0xF0F0F0), style: .init(lineWidth: .init(7)))
            .frame(width: 104, height: 104)
            .overlay {
                Circle()
                    .trim(from: 0, to: loaderTrim)
                    .stroke(Color(hex: 0x4AA1FD), style: .init(lineWidth: .init(7), lineCap: .round))
                    .rotationEffect(.degrees(-90))
            }
            .overlay {
                Circle()
                    .fill(Color(hex: 0x75B8FD))
                    .frame(76)
                    .overlay {
                        Image(.onboardingPlanCreating)
                            .resizable()
                            .scaledToFit()
                            .frame(36)
                    }
            }
            .scaleEffect(showText ? 1 : 1.4, anchor: .top)
            .animation(.easeInOut(duration: 0.45), value: showText)
    }
}

#Preview {
    OnboardingPlanCreatingScreen(onboardingVM: .init())
}
