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
        let firstPart = "Не переживайте, такое бывает.\n\n"
        var secondPart = ""

        if daysToEnd == 1 {
            secondPart = "До конца плана остался всего 1 день!\n"
        } else {
            secondPart = "До конца плана осталось всего 3 дня!\n"
        }

        let thirdPart = "Сегодняшний лимит - {exc} затяжки. Если уверены, что справитесь - продолжаем!\n\nА если вам нужно чуть больше времени - можем продлить план на 1 день. Лимит будет такой же, как вчера.".formatByDivider(
            divider: "{exc}",
            count: todayLimit
        )

        return [1, 3].contains(daysToEnd) ? (firstPart + secondPart + thirdPart) : (firstPart + thirdPart)
    }

    private var nonCriticalText: String {
        let firstPart = "Не переживайте, такое бывает. Продолжаем двигаться вперед!\n\n"

        var secondPart: String = ""

        if daysToEnd == 0 {
            secondPart = "Сегодня - последний день плана!\n"
        } else if daysToEnd == 1 {
            secondPart = "До конца плана остался всего 1 день!\n"
        } else {
            secondPart = "До конца плана осталось всего 3 дня!\n"
        }

        let thirdPart = "Сегодняшний лимит - {exc} затяжек.".formatByDivider(
            divider: "{exc}",
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
            .transition(
                .asymmetric(
                    insertion: .opacity.animation(.easeInOut(duration: 0.3).delay(0.3)),
                    removal: .opacity
                ).animation(.easeInOut(duration: 0.3))
            )

            VStack(spacing: 10) {
                AccentButton(text: isCriticallyExceeded ? "Я справлюсь!" : "Ok", action: onDismiss)

                Group {
                    if isCriticallyExceeded && !shouldShowPlanExtendedWarning {
                        SecondaryButton(text: "Продлить план на 1 день") {
                            extendPlan()
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: shouldShowPlanExtendedWarning)
            }
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 16)
        .animation(.easeInOut(duration: 0.25), value: shouldShowPlanExtendedWarning)
    }

    @ViewBuilder
    private func criticalExceededView() -> some View {
        VStack(spacing: 18) {
            Image(.yesterdayPlanExceededBadImageSvg)
                .resizable()
                .scaledToFit()
                .frame(68)
                .padding(.bottom, -14)

            MarkdownText(
                text: "Вчера вы превысили лимит на {exc} затяжек".formatByDivider(divider: "{exc}", count: yesterdedExceed),
                markdowns: [
                    "{exc} затяжек".formatByDivider(divider: "{exc}", count: yesterdedExceed)
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
            Image(.yesterdayPlanExceededNormal)
                .resizable()
                .scaledToFit()
                .frame(68)
                .padding(.bottom, -14)

            MarkdownText(
                text: "Вчера вы превысили лимит на {exc} затяжек".formatByDivider(divider: "{exc}", count: yesterdedExceed),
                markdowns: [
                    "{exc} затяжек".formatByDivider(divider: "{exc}", count: yesterdedExceed)
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
            Image(.yesterdayPlanExceededNormal)
                .resizable()
                .scaledToFit()
                .frame(68)
                .padding(.bottom, -14)

            MarkdownText(
                text: "План продлен на 1 день",
                markdowns: ["1 день"]
            )
            .font(.bold22)
            .multilineTextAlignment(.center)

            Text(
                "Сегодняшний лимит — {exc} затяжек".formatByDivider(
                    divider: "{exc}",
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
