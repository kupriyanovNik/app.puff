//
//  ActionMenuReadyToBreakView.swift
//  Puff
//
//  Created by Никита Куприянов on 29.09.2024.
//

import SwiftUI

struct ActionMenuReadyToBreakView: View {

    @State private var screenState: ScreenState = .base

    var tappedReadyToBreak: Bool
    var todayLimit: Int

    var onBreak: () -> Void = {}
    var onNeedOneMoreDay: () -> Void = {}
    var onDismiss: () -> Void = {}

    private var accentButtonText: String {
        screenState == .ready ? "Ура!" : screenState == .needDay ? "Ok" : "Да! Бросаем!"
    }

    var body: some View {
        VStack(spacing: 32) {
            Group {
                switch screenState {
                case .base: baseView()
                case .needDay: needDayView()
                case .ready: readyView()
                }
            }
            .transition(
                .asymmetric(
                    insertion: .opacity.animation(.easeInOut(duration: 0.3).delay(0.3)),
                    removal: .opacity
                ).animation(.easeInOut(duration: 0.3))
            )

            VStack(spacing: 10) {
                AccentButton(
                    text: accentButtonText,
                    background: screenState == .ready ? Color(hex: 0xFABC18) : Palette.accentColor
                ) {
                    nextButtonAction(needOneMoreDay: false)
                }

                Group {
                    if screenState == .base {
                        SecondaryButton(
                            text: tappedReadyToBreak ? "Нет, еще не готов" : "Мне нужен еще 1 день"
                        ) {
                            nextButtonAction(needOneMoreDay: true)
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: screenState)
            }
            .padding(.horizontal, 12)
        }
        .padding(.bottom, 16)
    }

    @ViewBuilder
    private func baseView() -> some View {
        VStack(spacing: 18) {
            VStack(spacing: 4) {
                Image(.onboardingPlanEnding)
                    .resizable()
                    .scaledToFit()
                    .frame(68)

                MarkdownText(
                    text: "Это была последняя затяжка",
                    markdowns: ["последняя затяжка"]
                )
                .font(.bold22)
                .multilineTextAlignment(.center)
            }

            Text("Вы прошли долгий путь. Сейчас - решающий момент. Вы готовы бросить парить?")
                .font(.medium16)
                .multilineTextAlignment(.center)
                .foregroundStyle(Palette.textSecondary)
        }
        .padding(.horizontal, 12)
    }

    @ViewBuilder
    private func needDayView() -> some View {
        VStack(spacing: 18) {
            Image(.homeOK)
                .resizable()
                .scaledToFit()
                .frame(68)
                .padding(.bottom, -14)

            MarkdownText(
                text: "План продлен на 1 день",
                markdowns: ["1 день"]
            )
            .font(.bold22)
            .lineLimit(2)

            Text("Сегодняшний лимит — {count} затяжки".formatByDivider(divider: "{count}", count: todayLimit))
                .font(.medium16)
                .multilineTextAlignment(.center)
                .foregroundStyle(Palette.textSecondary)
        }
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private func readyView() -> some View {
        VStack(spacing: 18) {
            Image(.actionMenuBroke)
                .resizable()
                .scaledToFit()
                .frame(68)
                .padding(.bottom, -14)

            MarkdownText(
                text: "Вы сделали это!\nПоздравляем!",
                markdowns: ["Поздравляем!"],
                accentColor: Color(hex: 0xFABC18)
            )
            .font(.bold22)
            .multilineTextAlignment(.center)
            .lineLimit(3)

            Text("Вы успешно справились с планом и бросили парить. Гордимся вами!")
                .font(.medium16)
                .multilineTextAlignment(.center)
                .foregroundStyle(Palette.textSecondary)
        }
        .padding(.horizontal, 24)
    }

    private func nextButtonAction(needOneMoreDay: Bool) {
        if screenState == .base {
            if needOneMoreDay {
                if tappedReadyToBreak {
                    onDismiss()
                } else {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        screenState = .needDay
                    }
                    onNeedOneMoreDay()
                }
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    screenState = .ready
                }
                onBreak()
            }
        } else {
            onDismiss()
        }
    }
}

#Preview {
    ActionMenuReadyToBreakView(tappedReadyToBreak: false, todayLimit: 32)
}

private extension ActionMenuReadyToBreakView {
    enum ScreenState {
        case base, needDay, ready

        var accentText: String {
            switch self {
            case .base: "Да! Бросаем!"
            case .needDay: "Ок"
            case .ready: "Ура!"
            }
        }
    }
}
