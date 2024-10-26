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
    var isLastSmoke: Bool
    var todayLimit: Int

    var onBreak: () -> Void = {}
    var onNeedOneMoreDay: () -> Void = {}
    var onDismiss: () -> Void = {}
    var onTappedWowButton: () -> Void = {}

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
                    insertion: .opacity.animation(.mainAnimation.delay(0.3)),
                    removal: .opacity
                ).animation(.mainAnimation)
            )

            VStack(spacing: 10) {
                AccentButton(
                    text: screenState.accentText,
                    background: screenState == .ready ? Color(hex: 0xFABC18) : Palette.accentColor
                ) {
                    nextButtonAction(needOneMoreDay: false)
                }

                Group {
                    if screenState == .base {
                        SecondaryButton(
                            text: tappedReadyToBreak ? "ActionMenuReadyToBreakView.Base.NotReady".l : "ActionMenuReadyToBreakView.Base.Need1Day".l
                        ) {
                            nextButtonAction(needOneMoreDay: true)
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .animation(.mainAnimation, value: screenState)
            }
            .padding(.horizontal, 12)
        }
        .padding(.bottom, 16)
    }

    @ViewBuilder
    private func baseView() -> some View {
        VStack(spacing: 18) {
            VStack(spacing: 4) {
                LottieView(name: "ActionMenuReadyToBreakBaseAnimation", loopMode: .loop, delay: 0.3)
                    .frame(68)

                MarkdownText(
                    text: isLastSmoke ? "ActionMenuReadyToBreakView.Base.Title2".l :
                        "ActionMenuReadyToBreakView.Base.Title1".l,
                    markdowns: [
                        "последняя затяжка",
                        "бросить?",
                        "last puff",
                        "quit"
                    ]
                )
                .font(.bold22)
                .multilineTextAlignment(.center)
            }

            Text("ActionMenuReadyToBreakView.Base.Description".l)
                .font(.medium16)
                .multilineTextAlignment(.center)
                .foregroundStyle(Palette.textSecondary)
        }
        .padding(.horizontal, 12)
    }

    @ViewBuilder
    private func needDayView() -> some View {
        VStack(spacing: 18) {
            if screenState == .needDay {
                LottieView(name: "ActionMenuReadyToBreakNeedDayAnimation", delay: 0.3)
                    .frame(68)
                    .padding(.bottom, -14)
            }

            MarkdownText(
                text: "ActionMenuReadyToBreakView.NeedDay.Title".l,
                markdowns: ["1 день", "1 day"]
            )
            .font(.bold22)
            .multilineTextAlignment(.center)
            .lineLimit(2)

            Text(
                "ActionMenuReadyToBreakView.NeedDay.TodayLimit".l.formatByDivider(
                    divider: "{count}",
                    count: todayLimit
                )
            )
            .font(.medium16)
            .multilineTextAlignment(.center)
            .foregroundStyle(Palette.textSecondary)
        }
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private func readyView() -> some View {
        VStack(spacing: 18) {
            LottieView(name: "ActionMenuReadyToBreakReadyAnimation", loopMode: .loop, delay: 0.3)
                .frame(68)
                .padding(.bottom, -14)

            MarkdownText(
                text: "ActionMenuReadyToBreakView.Broke.Title".l,
                markdowns: ["Поздравляем!", "Congratulations!"],
                accentColor: Color(hex: 0xFABC18)
            )
            .font(.bold22)
            .multilineTextAlignment(.center)
            .lineLimit(3)

            Text("ActionMenuReadyToBreakView.Broke.Description".l)
                .font(.medium16)
                .multilineTextAlignment(.center)
                .foregroundStyle(Palette.textSecondary)
        }
        .padding(.horizontal, 24)
    }

    private func nextButtonAction(needOneMoreDay: Bool) {
        if screenState == .base {
            if needOneMoreDay {
                if tappedReadyToBreak && !isLastSmoke {
                    onDismiss()
                } else {
                    withAnimation(.mainAnimation) {
                        screenState = .needDay
                    }

                    onNeedOneMoreDay()
                }
            } else {
                withAnimation(.mainAnimation) {
                    screenState = .ready
                }
                onBreak()
            }
        } else if screenState == .ready {
            onDismiss()
            onTappedWowButton()
        } else {
            onDismiss()
        }
    }
}

#Preview {
    ActionMenuReadyToBreakView(tappedReadyToBreak: false, isLastSmoke: true, todayLimit: 32)
}

private extension ActionMenuReadyToBreakView {
    enum ScreenState {
        case base, needDay, ready

        var accentText: String {
            switch self {
            case .base: "ActionMenuReadyToBreakView.Base.YesImBreaking".l
            case .needDay: "Ок"
            case .ready: "ActionMenuReadyToBreakView.Broke.Yay".l
            }
        }
    }
}
