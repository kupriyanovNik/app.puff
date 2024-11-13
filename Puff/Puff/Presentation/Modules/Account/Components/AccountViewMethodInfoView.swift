//
//  AccountViewMethodInfoView.swift
//  Puff
//
//  Created by Никита Куприянов on 10.11.2024.
//

import SwiftUI

struct AccountViewMethodInfoView: View {

    var backAction: () -> Void

    @State private var index: Int = 0

    private let maxIndex: Int = 4

    private let models: [AccountViewMethodInfoModel] = [
        .init(
            title: "OnboardingValuePropositionScreen.title1".l,
            titleMarkdowns: ["навсегда", "for good"],
            imageName: "OnboardingImages.ValueProposition1Image".l,
            description: "OnboardingValuePropositionScreen.text1".l
        ),
        .init(
            title: "AccountMethod.Title2".l,
            titleMarkdowns: ["95% людей,", "95% of people"],
            imageName: "onboardingSkipped1Image",
            imageFrame: 64,
            description: "AccountMethod.Description2".l,
            descriptionMarkdowns: ["Dr. J. Taylor Hays (2022),"],
            urlString: "https://truthinitiative.org/research-resources/quitting-smoking-vaping/why-cold-turkey-method-quitting-vaping-or-smoking-doesnt"
        ),
        .init(
            title: "OnboardingSurvey.SkippedScreen.Title2".l,
            titleMarkdowns: ["постепенного бросания", "gradual quitting approach"],
            imageName: "onboardingSkipped2Image",
            imageFrame: 64,
            description: "OnboardingSurvey.SkippedScreen.Description2".l
        ),
        .init(
            title: "OnboardingValuePropositionScreen.title2".l,
            titleMarkdowns: ["Отмечайте затяжки", "Track your puffs"],
            imageName: "OnboardingImages.ValueProposition2Image".l,
            description: "OnboardingValuePropositionScreen.text2".l
        ),
        .init(
            title: "OnboardingValuePropositionScreen.title4".l,
            titleMarkdowns: ["будет уменьшаться,", "will gradually decrease"],
            imageName: "OnboardingImages.ValueProposition4Image".l,
            description: "OnboardingValuePropositionScreen.text4".l
        )
    ]

    var body: some View {
        CircledTopCornersView(background: .init(hex: 0xF5F5F5), content: viewContent)
    }

    @ViewBuilder
    private func viewContent() -> some View {
        VStack(spacing: 24) {
            headerView()

            tabView()

            tabViewIndicator(dotIndex: index)
                .hLeading()
                .padding(.horizontal, 20)

            AccentButton(
                text: index == maxIndex ? "AccountMethod.Back".l : "Next".l,
                action: nextButtonAction
            )
            .contentTransition(.identity)
            .padding(.horizontal, 12)
            .padding(.bottom, 16)
        }
    }

    @ViewBuilder
    private func headerView() -> some View {
        HStack(spacing: 8) {
            Button(action: backAction) {
                Image(.accountBack)
                    .resizable()
                    .scaledToFit()
                    .frame(26)
            }

            Text("Account.Method".l)
                .font(.semibold22)
                .foregroundStyle(Palette.textPrimary)

            Spacer()
        }
        .padding(.top, 10)
        .padding(.leading, 16)
    }

    @ViewBuilder
    private func tabView() -> some View {
        TabView(selection: $index) {
            ForEach(0..<maxIndex + 1) { index in
                tabForIndex(index)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }

    @ViewBuilder
    private func tabForIndex(_ index: Int) -> some View {
        let model = models.safeIndex(index)

        VStack(spacing: 24) {
            Group {
                if let frame = model.imageFrame {
                    Image(model.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(frame)
                } else {
                    Image(model.imageName)
                        .resizable()
                        .scaledToFit()
                }
            }
            .vBottom()
            .hLeading()

            VStack(spacing: 12) {
                MarkdownText(text: model.title, markdowns: model.titleMarkdowns)
                    .font(.bold28)
                    .multilineTextAlignment(.leading)
                    .hLeading()

                MarkdownText(
                    text: model.description,
                    markdowns: model.descriptionMarkdowns,
                    foregroundColor: Palette.textSecondary
                )
                .font(.medium16)
                .multilineTextAlignment(.leading)
                .hLeading()
                .onTapGesture {
                    if let urlString = model.urlString {
                        urlString.openURL()
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .padding(.horizontal, 12)
    }

    @ViewBuilder
    private func tabViewIndicator(dotIndex: Int) -> some View {
        HStack(spacing: 5) {
            ForEach(0..<maxIndex + 1) { index in
                Circle()
                    .fill(Palette.textPrimary.opacity(index == dotIndex ? 1 : 0.3))
                    .frame(6)
            }
        }
    }

    private func nextButtonAction() {
        if index < maxIndex {
            withAnimation(.mainAnimation) {
                index += 1
            }
        } else {
            backAction()
        }
    }
}

#Preview {
    AccountViewMethodInfoView { }
}

extension AccountViewMethodInfoView {
    struct AccountViewMethodInfoModel: Identifiable {
        let id = UUID()

        let title: String
        let titleMarkdowns: [String]
        let imageName: String
        var imageFrame: CGFloat?
        let description: String
        var descriptionMarkdowns: [String] = []
        var urlString: String?
    }
}
