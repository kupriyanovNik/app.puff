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
        if let reasonIndex, reasonIndex < 3 {
            return [
                "OnboardingSurvey.SkippedScreen.Title1WithReason\(reasonIndex + 1)".l,
                "OnboardingSurvey.SkippedScreen.Title2".l,
                "OnboardingSurvey.SkippedScreen.Title3".l
            ]
        }

        return [
            "OnboardingSurvey.SkippedScreen.Title1WithourReason".l,
            "OnboardingSurvey.SkippedScreen.Title2".l,
            "OnboardingSurvey.SkippedScreen.Title3".l
        ]
    }


    private var titleMarks: [[String]] {
        let first: [String] = {
            switch reasonIndex {
            case 0: ["Резкий отказ", "сильной ломке", "cold turkey", "intense cravings"]
            case 1: ["Резкий отказ", "сильному стрессу", "cold turkey", "intense stress"]
            case 2: ["Резкий отказ", "поддержки среди окружающих,", "cold turkey,", "those around you,"]
            default: ["Резкий отказ", "срыву", "cold turkey", "relapse"]
            }
        }()

        return [
            reasonIndex != nil ? first : ["Резкий отказ", "срыву", "cold turkey", "relapse"],
            ["постепенного бросания", "gradual quitting approach"],
            ["Навсегда", "Forever"]
        ]

    }

    private let descriptions: [String] = Array((1...3).map { "OnboardingSurvey.SkippedScreen.Description\($0)".l })

    var body: some View {
        VStack(spacing: 35) {
            Spacer()

            tabView()

            AccentButton(text: "Next".l, action: nextButtonAction)
                .padding(.horizontal, 12)
                .padding(.bottom, -16)
        }
        .background(.white)
        .prepareForStackPresentation()
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
