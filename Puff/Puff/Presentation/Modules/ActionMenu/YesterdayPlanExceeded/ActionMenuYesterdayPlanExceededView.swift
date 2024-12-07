//
//  ActionMenuYesterdayPlanExceededView.swift
//  Puff
//
//  Created by Никита Куприянов on 26.09.2024.
//

import SwiftUI

struct ActionMenuYesterdayPlanExceededView: View {

    var todayLimit: Int
    var yesterdayLimit: Int
    var yesterdedExceed: Int
    var daysToEnd: Int

    var onExtendPlan: () -> Void
    var onDismiss: () -> Void

    @State private var shouldShowPlanExtendedWarning: Bool = false

    private var isCriticallyExceeded: Bool {
        (yesterdayLimit >= 50 && yesterdedExceed > 10) || (yesterdayLimit < 50 && yesterdedExceed > 5)
    }

    private var criticalText: String {
        let firstPart = "ActionMenuYesterdayExceeded.Critical.First".l
        var secondPart = ""

        if daysToEnd == 0 {
            secondPart = "ActionMenuYesterdaySuccessed.LastDay".l
        } else if daysToEnd == 1 {
            secondPart = "ActionMenuYesterdaySuccessed.1DayLeast".l
        } else {
            secondPart = "ActionMenuYesterdaySuccessed.3DaysLeast".l
        }

        let thirdPart = "ActionMenuYesterdayExceeded.Critical.Third".l.formatByDivider(
            divider: "{count}",
            count: todayLimit
        )

        return [0, 1, 3].contains(daysToEnd) ? (firstPart + secondPart + thirdPart) : (firstPart + thirdPart)
    }

    private var nonCriticalText: String {
        let firstPart = "ActionMenuYesterdayExceeded.NonCritical.First".l

        var secondPart: String = ""

        if daysToEnd == 0 {
            secondPart = "ActionMenuYesterdaySuccessed.LastDay".l
        } else if daysToEnd == 1 {
            secondPart = "ActionMenuYesterdaySuccessed.1DayLeast".l
        } else {
            secondPart = "ActionMenuYesterdaySuccessed.3DaysLeast".l
        }

        let thirdPart = "ActionMenuYesterdayExceeded.NonCritical.Third".l.formatByDivider(
            divider: "{count}",
            count: todayLimit
        )

        return [0, 1, 3].contains(daysToEnd) ? (firstPart + secondPart + thirdPart) : (firstPart + thirdPart)
    }

    var body: some View {
        VStack(spacing: 32) {
            Group {
                if isCriticallyExceeded {
                    if shouldShowPlanExtendedWarning {
                        planExtendedView()
                    } else {
                        criticalExceededView()
                    }
                } else {
                    nonCriticalExceededView()
                }
            }
            .makeActionMenuTransition()

            VStack(spacing: 10) {
                AccentButton(text: isCriticallyExceeded ? "ActionMenuYesterdayExceeded.CanDoIt".l : "Ok".l) {
                    HapticManager.actionMenusButton()
                    onDismiss()
                }

                Group {
                    if isCriticallyExceeded && !shouldShowPlanExtendedWarning {
                        SecondaryButton(text: "ActionMenuYesterdayExceeded.ExtendPlan".l) {
                            HapticManager.actionMenusButton()
                            extendPlan()
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .animation(.mainAnimation, value: shouldShowPlanExtendedWarning)
            }
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 16)
        .animation(.easeInOut(duration: 0.25), value: shouldShowPlanExtendedWarning)
    }

    @ViewBuilder
    private func criticalExceededView() -> some View {
        VStack(spacing: 18) {
            LottieView(name: "ActionMenuYesterdayPlanExceededCriticalAnimation", delay: 0.3)
                .frame(68)
                .padding(.bottom, -14)

            MarkdownText(
                text: "ActionMenuYesterdayExceeded.Critical.Title".l.formatByDivider(divider: "{count}", count: yesterdedExceed),
                markdowns: [
                    "превысили лимит",
                    "{count} puffs".formatByDivider(divider: "{count}", count: yesterdedExceed)
                ],
                accentColor: Color(hex: 0xFF7D7D)
            )
            .font(.bold22)
            .multilineTextAlignment(.center)

            Text(criticalText)
                .font(.semibold16)
                .multilineTextAlignment(.center)
                .foregroundStyle(Palette.textSecondary)
        }
        .padding(.horizontal, 12)
    }

    @ViewBuilder
    private func nonCriticalExceededView() -> some View {
        VStack(spacing: 18) {
            LottieView(name: "ActionMenuYesterdayPlanExceededNonCriticalAnimation", delay: 0.3)
                .frame(68)
                .padding(.bottom, -14)

            MarkdownText(
                text: "ActionMenuYesterdayExceeded.Critical.Title".l.formatByDivider(divider: "{count}", count: yesterdedExceed),
                markdowns: [
                    "превысили лимит",
                    "{count} puffs".formatByDivider(divider: "{count}", count: yesterdedExceed)
                ]
            )
            .font(.bold22)
            .multilineTextAlignment(.center)

            Text(nonCriticalText)
                .font(.medium16)
                .multilineTextAlignment(.center)
                .foregroundStyle(Palette.textSecondary)
        }
        .padding(.horizontal, 12)
    }

    @ViewBuilder
    private func planExtendedView() -> some View {
        VStack(spacing: 18) {
            if shouldShowPlanExtendedWarning {
                LottieView(name: "ActionMenuReadyToBreakNeedDayAnimation", delay: 0.3)
                    .frame(68)
                    .padding(.bottom, -14)
            }

            MarkdownText(
                text: "ActionMenuYesterdayExceeded.PlanExtended".l,
                markdowns: ["1 день", "1 day"]
            )
            .font(.bold22)
            .multilineTextAlignment(.center)

            Text(
                "ActionMenuYesterdayExceeded.NonCritical.Third".l.formatByDivider(
                    divider: "{count}",
                    count: todayLimit
                )
            )
            .font(.medium16)
            .multilineTextAlignment(.center)
            .foregroundStyle(Palette.textSecondary)
        }
        .padding(.horizontal, 12)
    }

    private func extendPlan() {
        if !shouldShowPlanExtendedWarning {
            withAnimation(.easeInOut(duration: 0.25)) {
                shouldShowPlanExtendedWarning = true
                onExtendPlan()
            }
        } else {
            onDismiss()
        }
    }
}

#Preview {
    ActionMenuYesterdayPlanExceededView(
        todayLimit: 1000,
        yesterdayLimit: 100,
        yesterdedExceed: 12,
        daysToEnd: 5
    ) {

    } onDismiss: {

    }
}
