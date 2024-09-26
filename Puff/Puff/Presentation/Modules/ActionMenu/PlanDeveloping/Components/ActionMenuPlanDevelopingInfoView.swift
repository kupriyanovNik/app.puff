//
//  ActionMenuPlanDevelopingInfoView.swift
//  Puff
//
//  Created by Никита Куприянов on 26.09.2024.
//

import SwiftUI

struct ActionMenuPlanDevelopingInfoView: View {

    var selectedOption: ActionMenuPlanDevelopingPeriod

    let images: [String] = [
        "onboardingPlan1Image",
        "onboardingPlan2Image",
        "onboardingPlan3Image"
    ]

    let descriptions: [String] = [
        "Выберем стартовое количество затяжек и начнем план",
        "Лимит затяжек на день будет постепенно уменьшаться",
        "Вы сделаете свою последнюю затяжку и бросите парить"
    ]

    var titles: [String] {
        [
            "Сегодня",
            "Дни 2-\(selectedOption.rawValue-1)",
            "День \(selectedOption.rawValue)"
        ]
    }

    var body: some View {
        VStack(spacing: 28) {
            MarkdownText(
                text: "Выбранный план: \(selectedOption.title)",
                markdowns: ["\(selectedOption.rawValue) дней", "\(selectedOption.rawValue) день"]
            )
            .font(.bold22)

            VStack(alignment: .leading, spacing: 26) {
                ForEach(0..<3) { index in
                    HStack(spacing: 10) {
                        Image(images[index])
                            .resizable()
                            .scaledToFit()
                            .frame(48)

                        VStack(spacing: 4) {
                            Text(titles[index])
                                .font(.bold18)
                                .foregroundStyle(Palette.textPrimary)
                                .hLeading()

                            Text(descriptions[index])
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
}

#Preview {
    ActionMenuPlanDevelopingInfoView(selectedOption: .mid)
}
