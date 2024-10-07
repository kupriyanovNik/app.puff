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

    let descriptions: [String] = Array((1...3).map { "OnboardingPlanInfo.Description\($0)".l })

    var titles: [String] {
        [
            "OnboardingPlanInfo.Title1".l,
            "ActionMenuPlanDeveloping.Info.Description2Title".l.formatByDivider(
                divider: "{count}",
                count: (selectedOption.rawValue-1)
            ),
            "ActionMenuPlanDeveloping.Info.Description3Title".l.formatByDivider(
                divider: "{count}",
                count: (selectedOption.rawValue)
            )
        ]
    }

    var body: some View {
        VStack(spacing: 28) {
            MarkdownText(
                text: "ActionMenuPlanDeveloping.Info.Title".l + selectedOption.title,
                markdowns: [
                    "\(selectedOption.rawValue) дней",
                    "\(selectedOption.rawValue) день",
                    "\(selectedOption.rawValue) days"
                ]
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
