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
    @State private var lineWidth: Double = 7

    var body: some View {
        VStack(spacing: 18) {
            Spacer()

            loaderView()

            MarkdownText(
                text: "Определяем наиболее подходящий вам план бросания...",
                markdown: "план бросания..."
            )
            .font(.bold22)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 30)

            Spacer()
        }
        .prepareForStackPresentationInOnboarding()
        .onAppear {
            delay(1) {
                withAnimation(.linear(duration: 4)) {
                    loaderTrim = 1
                }
            }
        }
        .onAppear {
            delay(5) {
                withAnimation(.linear(duration: 0.3)) {
                    lineWidth = 10
                }

                delay(0.5) {
                    withAnimation(.linear(duration: 0.3)) {
                        lineWidth = 7
                    }
                }
            }
        }
        .onAppear {
            delay(6.5) {
                onboardingVM.nextScreen()
            }
        }
    }

    @ViewBuilder
    private func loaderView() -> some View {
        Circle()
            .stroke(Color(hex: 0xF0F0F0), style: .init(lineWidth: .init(lineWidth)))
            .frame(width: 104, height: 104)
            .overlay {
                Circle()
                    .trim(from: 0, to: loaderTrim)
                    .stroke(Color(hex: 0x4AA1FD), style: .init(lineWidth: .init(lineWidth), lineCap: .round))
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
    }
}

#Preview {
    OnboardingPlanCreatingScreen(onboardingVM: .init())
}
