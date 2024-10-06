//
//  OnboardingSurveySkippedScreen.swift
//  Puff
//
//  Created by Никита Куприянов on 20.09.2024.
//

import SwiftUI

struct OnboardingSurveySkippedScreen: View {

    @State private var selectedTabIndex: Int = 0

    @ObservedObject var onboardingVM: OnboardingViewModel

    var reasonIndex: Int?

    private var titles: [String] {

        let withReason = reasonIndex != nil

        let first: String = {
            switch reasonIndex {
            case 0: "Резкий отказ от вредной привычки почти всегда приводит к сильной ломке и дальнейшему срыву"
            case 1: "Резкий отказ от вредной привычки почти всегда приводит к сильному стрессу и дальнейшему срыву"
            case 2: "Резкий отказ, если не встречает поддержки среди окружающих, почти всегда приводит к срыву"
            default: "Резкий отказ от вредной привычки почти всегда приводит к срыву"
            }
        }()

        return [
            withReason ? first : "Резкий отказ от вредной привычки почти всегда приводит к срыву",
            "Puffless использует метод постепенного бросания",
            "Привычка парить останется в прошлом. Навсегда"
        ]
    }


    private var titleMarks: [[String]] {

        let withReason = reasonIndex != nil

        let first: [String] = {
            switch reasonIndex {
            case 0: ["Резкий отказ", "сильной ломке"]
            case 1: ["Резкий отказ", "сильному стрессу"]
            case 2: ["Резкий отказ", "поддержки среди окружающих,"]
            default: ["Резкий отказ", "срыву"]
            }
        }()

        return [
            withReason ? first : ["Резкий отказ", "срыву"],
            ["постепенного бросания"],
            ["Навсегда"]
        ]

    }

    private let descriptions: [String] = [
        "Организму сложно справиться с внезапными изменениями. Появляется сильнейшая ломка, заставляющая возобновить привычку.",
        "Мы построим ваш личный план бросания, опираясь на силу вашей привычки и срок, за который вы хотите бросить.",
        "Плавный отказ позволит организму легко привыкнуть к изменениям - вы не только окончательно бросите, но и навсегда избавитесь от тяги к парению!"
    ]

    var body: some View {
        VStack(spacing: 35) {
            Spacer()

            tabView()

            AccentButton(text: "Next".l, action: nextButtonAction)
                .padding(.horizontal, 12)
                .padding(.bottom, -16)
        }
        .background(.white)
        .prepareForStackPresentationInOnboarding()
    }

    @ViewBuilder
    private func tabView() -> some View {
        TabView(selection: $selectedTabIndex) {
            ForEach(0..<3) { index in
                tabForIndex(index)
                    .tag(index)
                    .vBottom()
                    .ignoresSafeArea()
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
    }

    @ViewBuilder
    private func tabForIndex(_ index: Int) -> some View {
        let imageName: String = "onboardingSkipped\(index + 1)Image"

        VStack(spacing: 26) {
            VStack(spacing: 18) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(64)
                    .hLeading()

                VStack(spacing: 12) {
                    MarkdownText(text: titles[index], markdowns: titleMarks[index])
                        .font(.bold28)
                        .foregroundStyle(Palette.textPrimary)
                        .hLeading()

                    Text(descriptions[index])
                        .font(.medium16)
                        .foregroundStyle(Palette.textPrimary.opacity(0.56))
                        .hLeading()
                }
                .multilineTextAlignment(.leading)
            }

            tabViewIndicator(dotIndex: index)
                .hLeading()
        }
        .padding(.horizontal, 20)
    }


    @ViewBuilder
    private func tabViewIndicator(dotIndex: Int) -> some View {
        HStack(spacing: 5) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Palette.textPrimary.opacity(index == dotIndex ? 1 : 0.3))
                    .frame(6)
            }
        }
    }

    private func nextButtonAction() {
        if selectedTabIndex < 2 {
            animated {
                selectedTabIndex += 1
            }
        } else {
            onboardingVM.backToQuestionsFromSkippedView()
        }
    }
}

#Preview {
    OnboardingSurveySkippedScreen(onboardingVM: .init())
}
