//
//  ActionMenuSubscriptionLeavingView.swift
//  Puff
//
//  Created by Никита Куприянов on 29.09.2024.
//

import SwiftUI

struct ActionMenuSubscriptionLeavingView: View {

    @State private var screenState: ScreenState = .reasons

    @SceneStorage("reasonsIndices") private var reasonsIndices: [Int] = []
    @SceneStorage("improvementsString") private var improvementsString: String = ""

    var onCancelSubscription: ([Int], String) -> Void = { _, _ in }
    var onDismiss: () -> Void = {}

    private let reasons: [String] = [
        "Я уже успешно бросил (а)",
        "Приложение не помогло бросить",
        "Нет нужных мне функций",
        "Приложение слишком сложное",
        "Слишком дорого",
        "Другое"
    ]

    private var nextButtonDisabled: Bool {
        if screenState == .reasons { return reasonsIndices.isEmpty }

        return false
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
            .transition(
                .asymmetric(
                    insertion: .opacity.animation(.easeInOut(duration: 0.3).delay(0.3)),
                    removal: .opacity
                ).animation(.easeInOut(duration: 0.3))
            )

            VStack(spacing: 10) {
                AccentButton(
                    text: screenState == .cancel ? "Отменить подписку" : "Далее",
                    isDisabled: nextButtonDisabled,
                    action: nextAction
                )

                Group {
                    if screenState == .cancel {
                        TextButton(text: "Оставить Premium", font: .medium16) {
                            onDismiss()
                        }
                        .hCenter()
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: screenState)
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 12)
        .padding(.bottom, 16)
        .keyboardAwarePadding()
    }

    @ViewBuilder
    private func reasonsView() -> some View {
        VStack(spacing: 18) {
            Text("Почему вы уходите?")
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
                text: "Расскажите, что мы можем улучшить?",
                markdowns: ["улучшить?"]
            )
            .font(.bold22)
            .multilineTextAlignment(.center)
            .foregroundStyle(Palette.textPrimary)
            .padding(.horizontal, 24)

            MainInputField(
                text: $improvementsString,
                placeholder: "Обратная связь",
                height: 140
            )
            .onTapContinueEditing()
        }
        .onTapEndEditing()
    }

    @ViewBuilder
    private func cancelView() -> some View {
        VStack(spacing: 18) {
            Text("Спасибо!")
                .font(.bold22)
                .foregroundStyle(Palette.textPrimary)
                .padding(.horizontal, 24)

            Text("Рады, что вы были с нами. Теперь вы можете отменить подписку")
                .font(.medium16)
                .multilineTextAlignment(.center)
                .foregroundStyle(Palette.textSecondary)
                .padding(.horizontal, 12)
        }
    }

    private func nextAction() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if screenState == .reasons {
                screenState = .improvements
            } else if screenState == .improvements {
                screenState = .cancel
            } else if screenState == .cancel {
                onCancelSubscription(reasonsIndices, improvementsString)
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

