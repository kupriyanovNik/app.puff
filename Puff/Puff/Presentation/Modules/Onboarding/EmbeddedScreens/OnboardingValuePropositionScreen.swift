//
//  OnboardingValuePropositionScreen.swift
//  Puff
//
//  Created by Никита Куприянов on 19.09.2024.
//

import SwiftUI

struct OnboardingValuePropositionScreen: View {

    @State private var selectedTabIndex: Int = 0

    @ObservedObject var onboardingVM: OnboardingViewModel

    private let titleMarks: [[String]] = [
        ["навсегда", "for good"],
        ["Отмечайте затяжки", "Track your puffs"],
        ["виджеты,", "widgets", "shortcuts"],
        ["будет уменьшаться,", "will gradually decrease"]
    ]

    var body: some View {
        VStack {
            tabView()

            Spacer()

            AccentButton(text: "Next".l, action: nextButtonAction)
                .padding(.horizontal, 12)
        }
        .padding(.top, isSmallDevice ? 8 : 16)
        .padding(.bottom, 16)
        .prepareForStackPresentation()
    }

    @ViewBuilder
    private func tabView() -> some View {
        TabView(selection: $selectedTabIndex) {
            ForEach(0..<4) { index in
                tabForIndex(index)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }

    @ViewBuilder
    private func tabForIndex(_ index: Int) -> some View {
        let imageName: String = "OnboardingImages.ValueProposition\(index + 1)Image".l

        VStack(spacing: 26) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .cornerRadius(16)
                .padding(.horizontal, 12)

            VStack(spacing: 12) {
                MarkdownText(
                    text: "OnboardingValuePropositionScreen.title\(index + 1)".l,
                    markdowns: titleMarks[index]
                )
                .font(isSmallDevice ? .bold22 : .bold28)
                .foregroundStyle(Palette.textPrimary)
                .hLeading()

                VStack(spacing: isSmallDevice ? 18 : 24) {
                    Text("OnboardingValuePropositionScreen.text\(index + 1)".l)
                        .font(.medium16)
                        .foregroundStyle(Palette.textPrimary.opacity(0.56))
                        .hLeading()

                    tabViewIndicator(dotIndex: index)
                        .hLeading()
                }
            }
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 20)
        }
        .vTop()
    }

    @ViewBuilder
    private func tabViewIndicator(dotIndex: Int) -> some View {
        HStack(spacing: 5) {
            ForEach(0..<4) { index in
                Circle()
                    .fill(Palette.textPrimary.opacity(index == dotIndex ? 1 : 0.3))
                    .frame(6)
            }
        }
    }

    private func nextButtonAction() {
        if selectedTabIndex < 3 {
            animated(.mainAnimation) {
                selectedTabIndex += 1
            }
        } else {
            onboardingVM.nextScreen()
        }
    }
}

#Preview {
    OnboardingValuePropositionScreen(onboardingVM: .init())
}
