//
//  OnboardingPlanScreen.swift
//  Puff
//
//  Created by Никита Куприянов on 21.09.2024.
//

import SwiftUI

struct OnboardingPlanScreen: View {

    @ObservedObject var onboardingVM: OnboardingViewModel

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()

        formatter.setLocalizedDateFormatFromTemplate("dd MMMM")

        return formatter
    }()

    private var todayString: String {
        dateFormatter.string(from: .now)
    }

    private var endString: String {
        let end = Calendar.current.date(byAdding: .day, value: 21, to: .now) ?? .now

        return dateFormatter.string(from: end)
    }

    private let planDescription: [(title: String, desc: String, imageName: String)] = [
        (
            title: "Сегодня",
            desc: "Выберем стартовое количество затяжек и начнем план",
            imageName: "onboardingPlan1Image"
        ),
        (
            title: "Дни 2-20",
            desc: "Лимит затяжек на день будет постепенно уменьшаться",
            imageName: "onboardingPlan2Image"
        ),
        (
            title: "День 21",
            desc: "Вы сделаете свою последнюю затяжку и бросите парить",
            imageName: "onboardingPlan3Image"
        )
    ]

    private let isSmallDevice: Bool =  UIScreen.main.bounds.height < 700

    var body: some View {
        VStack(spacing: isSmallDevice ? 28 : 42) {
            topView()

            bottomView()
                .vTop()

            AccentButton(text: "Далее", action: onboardingVM.nextScreen)
                .padding(.horizontal, 12)
                .padding(.bottom, 16)
        }
    }

    @ViewBuilder
    private func topView() -> some View {
        VStack(spacing: isSmallDevice ? 4 : 20) {
            MarkdownText(
                text: "Оптимальный план:\n21 день",
                markdown: "21 день"
            )
            .font(.bold28)
            .lineLimit(2)
            .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                if isSmallDevice {
                    LottieView(name: "OnboardingChartSmallAnimation")
                } else {
                    LottieView(name: "OnboardingChartAnimation")
                }

                HStack {
                    Text(todayString)
                        .foregroundStyle(Color(hex: 0x0303034D).opacity(0.3))

                    Spacer()

                    HStack(spacing: 3) {
                        Image(.onboardingPlanEnding)
                            .resizable()
                            .scaledToFit()
                            .frame(24)

                        Text(endString)
                            .foregroundStyle(Color(hex: 0x4AA1FD))
                    }
                }
                .font(.semibold16)
            }
        }
        .padding(.top, 32)
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func bottomView() -> some View {
        VStack(alignment: .leading, spacing: 26) {
            ForEach(planDescription, id: \.title) { item in
                HStack(spacing: 10) {
                    Image(item.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(48)

                    VStack(spacing: 4) {
                        Text(item.title)
                            .font(.bold18)
                            .foregroundStyle(Palette.textPrimary)
                            .hLeading()

                        Text(item.desc)
                            .font(.medium16)
                            .foregroundStyle(Palette.textSecondary)
                            .multilineTextAlignment(.leading)
                            .hLeading()
                    }
                }
            }
        }
        .padding(.horizontal, 12)
    }
}

#Preview {
    OnboardingPlanScreen(onboardingVM: .init())
}
