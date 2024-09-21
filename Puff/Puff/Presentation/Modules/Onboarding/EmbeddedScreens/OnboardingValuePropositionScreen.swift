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

    private let titles: [String] = [
        "Puff Away поможет бросить без усилий и навсегда",
        "Отмечайте затяжки и не превышайте дневной лимит",
        "Каждый день лимит будет уменьшаться, пока вы не бросите!"
    ]

    private let titleMarks: [String] = [
        "навсегда",
        "Отмечайте затяжки",
        "будет уменьшаться,"
    ]

    private let descriptions: [String] = [
        "Резкий отказ почти всегда приводит к срыву. Мы используем метод постепенного бросания, чтобы организм успевал адаптироваться и не испытывал стресса.",
        "В отличие от резкого отказа, вы не будете ощущать лишений и сильных ограничений - соблюдать лимит будет нетрудно, а видеть ежедневный прогресс - бесценно!",
        "Процесс может идти как плавно, так и немного интенсивней - это зависит от желаемого срока отказа и силы вашей привычки."
    ]

    private let isSmallDevice = UIScreen.main.bounds.height < 700

    var body: some View {
        VStack {
            tabView()

            Spacer()

            AccentButton(text: "Далее", action: nextButtonAction)
                .padding(.horizontal, 12)
//                .padding(.top, isSmallDevice ? 0 : 65)
        }
        .padding(.top, isSmallDevice ? 8 : 16)
        .padding(.bottom, 16)
        .prepareForStackPresentationInOnboarding()
    }

    @ViewBuilder
    private func tabView() -> some View {
        TabView(selection: $selectedTabIndex) {
            ForEach(0..<3) { index in
                tabForIndex(index)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }

    @ViewBuilder
    private func tabForIndex(_ index: Int) -> some View {
        let imageName: String = "valueProposition\(index + 1)Image"

        VStack(spacing: 26) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 12)

            VStack(spacing: 12) {
                MarkdownText(text: titles[index], markdown: titleMarks[index])
                    .font(isSmallDevice ? .bold22 : .bold28)
                    .foregroundStyle(Palette.textPrimary)
                    .hLeading()

                VStack(spacing: isSmallDevice ? 18 : 24) {
                    Text(descriptions[index])
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
            onboardingVM.nextScreen()
        }
    }
}

#Preview {
    OnboardingValuePropositionScreen(onboardingVM: .init())
}
