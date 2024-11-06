//
//  ActionMenuSubscriptionLeavingView.swift
//  Puff
//
//  Created by Никита Куприянов on 29.09.2024.
//

import SwiftUI

struct ActionMenuSubscriptionLeavingView: View {

    @State private var screenState: ScreenState = .reasons

    @State private var reasonsIndices: [Int] = []
    @State private var improvementsString: String = ""

    var onCancelSubscription: ([Int], String) -> Void = { _, _ in }
    var onDismiss: () -> Void = {}

    private let reasons: [String] = Array((1...6).map { "AccountSubscription.Leaving.Base.Reason\($0)".l })

    private var nextButtonDisabled: Bool {
        if screenState == .reasons { return reasonsIndices.isEmpty }

        return false
    }

    private func sendAnalytics() {
        AnalyticsManager.logEvent(
            event: .canceledSubscription(
                reasons: Array(reasonsIndices.map { reasons[$0] }),
                feedback: improvementsString
            )
        )
    }

    var body: some View {
        VStack(spacing: 32) {
            Group {
                switch screenState {
                case .reasons: reasonsView()
                case .improvements: improvementsView()
                case .cancel: cancelView()
                }
            }
            .makeActionMenuTransition()

            VStack(spacing: 10) {
                AccentButton(
                    text: screenState == .cancel ? "AccountSubscription.CancelSubscription".l : "Next".l,
                    isDisabled: nextButtonDisabled,
                    action: nextAction
                )

                Group {
                    if screenState == .cancel {
                        TextButton(text: "AccountSubscription.Leaving.Cancel.StayPremium".l, font: .medium16) {
                            onDismiss()
                        }
                        .hCenter()
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .animation(.mainAnimation, value: screenState)
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 12)
        .padding(.bottom, 16)
        .removeSwipeToDismissWhenAppeared()
    }

    @ViewBuilder
    private func reasonsView() -> some View {
        VStack(spacing: 18) {
            Text("AccountSubscription.Leaving.Base.Title".l)
                .font(.bold22)
                .foregroundStyle(Palette.textPrimary)
                .padding(.horizontal, 24)

            TagLayoutView {
                ForEach(reasons.indices) { index in
                    reasonCell(index)
                }
            }
            .hLeading()
        }
    }

    @ViewBuilder
    private func reasonCell(_ index: Int) -> some View {
        let isSelected = reasonsIndices.contains(index)

        Text(reasons[index])
            .font(.medium16)
            .lineLimit(1)
            .foregroundStyle(isSelected ? .white : Palette.textSecondary)
            .padding(.vertical, 6)
            .padding(.horizontal, 16)
            .background {
                Capsule()
                    .fill(isSelected ? Palette.accentColor : Color(hex: 0xE7E7E7))
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.25)) {
                    if let index = reasonsIndices.firstIndex(of: index) {
                        reasonsIndices.remove(at: index)
                    } else {
                        reasonsIndices.append(index)
                    }
                }
            }
    }

    @ViewBuilder
    private func improvementsView() -> some View {
        VStack(spacing: 18) {
            MarkdownText(
                text: "AccountSubscription.Leaving.Improvements.Feedback".l,
                markdowns: ["улучшить?", "improve"]
            )
            .font(.bold22)
            .multilineTextAlignment(.center)
            .foregroundStyle(Palette.textPrimary)
            .padding(.horizontal, 24)

            MainInputField(
                text: $improvementsString,
                placeholder: "AccountSubscription.Leaving.Improvements.FeedbackPlaceholder".l,
                height: 140
            )
            .onTapContinueEditing()
        }
        .onTapEndEditing()
    }

    @ViewBuilder
    private func cancelView() -> some View {
        VStack(spacing: 18) {
            Text("AccountSubscription.Leaving.Cancel.Thanks".l)
                .font(.bold22)
                .foregroundStyle(Palette.textPrimary)
                .padding(.horizontal, 24)

            Text("AccountSubscription.Leaving.Cancel.ThanksFor".l)
                .font(.medium16)
                .multilineTextAlignment(.center)
                .foregroundStyle(Palette.textSecondary)
                .padding(.horizontal, 12)
        }
    }

    private func nextAction() {
        HapticManager.actionMenusButton()

        withAnimation(.mainAnimation) {
            if screenState == .reasons {
                screenState = .improvements
            } else if screenState == .improvements {
                screenState = .cancel
            } else if screenState == .cancel {
                onCancelSubscription(reasonsIndices, improvementsString)
                sendAnalytics()
                onDismiss()
            }
        }
    }
}

#Preview {
    ActionMenuSubscriptionLeavingView()
}

private extension ActionMenuSubscriptionLeavingView {
    enum ScreenState {
        case reasons, improvements, cancel
    }
}

