//
//  ActionMenuPlanDevelopingView.swift
//  Puff
//
//  Created by Никита Куприянов on 23.09.2024.
//

import SwiftUI

struct ActionMenuPlanDevelopingView: View {

    @State private var sliderPercentage: Double = 44
    @State private var selectedPeriod: ActionMenuPlanDevelopingPeriod = .mid

    @State private var screenState: ScreenState = .addiction

    var todaySmokes: Int

    var onStartedPlan: (ActionMenuPlanDevelopingPeriod, Int) -> Void = { _, _ in }
    var onDismiss: () -> Void = {}

    private let minSmokesCount: Int = 100
    private let maxSmokesCount: Int = 1000

    @State private var shouldShowError: Bool = false

    private var smokesCount: Int {
        let count = 10 * Int(round(Double(maxSmokesCount - minSmokesCount) * (sliderPercentage / 100) / 10.0)) + 100

        return count
    }

    var body: some View {
        VStack(spacing: 32) {
            Group {
                switch screenState {
                case .addiction:
                    addictionView()
                        .padding(.bottom, 12)
                case .plan:
                    ActionMenuPlanDevelopingPeriodPicker(selectedOption: $selectedPeriod)
                case .info:
                    ActionMenuPlanDevelopingInfoView(selectedOption: selectedPeriod)
                        .padding(.bottom, 12)
                }
            }
            .transition(
                .asymmetric(
                    insertion: .opacity.animation(.easeInOut(duration: 0.3).delay(0.3)),
                    removal: .opacity
                ).animation(.easeInOut(duration: 0.3))
            )

            AccentButton(
                text: screenState == .info ? "Начать" : "Далее",
                isDisabled: shouldShowError && todaySmokes < 1000,
                action: nextAction
            )
            .padding(.horizontal, 12)
        }
        .padding(.bottom, 16)
        .padding(.top, 20)
        .onChange(of: smokesCount) { _ in
            HapticManager.onTabChanged()
        }
        .onChange(of: smokesCount) { newValue in
            withAnimation(.easeInOut(duration: 0.25)) {
                shouldShowError = newValue < todaySmokes
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.25)) {
                shouldShowError = smokesCount < todaySmokes
            }
        }
    }

    @ViewBuilder
    private func addictionView() -> some View {
        VStack(spacing: 24) {
            VStack(spacing: 18) {
                Text("Сколько затяжек вы делаете в день?")
                    .font(.bold22)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Palette.textPrimary)
                    .padding(.horizontal, 12)

                Text("Можно указать примерное число - если в первые дни окажется, что лимит маловат, мы скорректируем его")
                    .font(.medium16)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Palette.textSecondary)
            }
            .padding(.horizontal, 24)

            VStack(spacing: 20) {
                infoView()

                ActionMenuPlanDevelopingSlider(
                    percentage: $sliderPercentage,
                    todaySmokes: todaySmokes
                )
                .padding(.horizontal, 40)
                .overlay {
                    Group {
                        if shouldShowError && todaySmokes < 1000 {
                            Text("Это меньше, чем вы уже сделали сегодня")
                                .font(.medium16)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .foregroundStyle(Color(hex: 0x4AA1FD))
                                .offset(y: 38)
                                .padding(.horizontal, 24)
                                .transition(.opacity)
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func infoView() -> some View {
        let addiction: String = {
            switch smokesCount {
            case 99...249: "Умеренная зависимость"
            case 250...399: "Серьезная зависимость"
            case 400...799: "Сильная зависимость"
            default: "Высочайшая зависимость"
            }
        }()

        VStack(spacing: 3) {
            Text("\(smokesCount)")
                .font(.bold52)
                .foregroundStyle(Palette.textPrimary)

            Text(addiction)
                .font(.medium15)
                .foregroundStyle(Palette.textSecondary)
                .padding(.vertical, 5)
                .padding(.horizontal, 12)
                .background {
                    Capsule()
                        .fill(Color(hex: 0xE7E7E7))
                }
        }
    }

    private func nextAction() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if screenState == .addiction {
                screenState = .plan
            } else if screenState == .plan {
                screenState = .info
            } else if screenState == .info {
                onStartedPlan(selectedPeriod, smokesCount)

                onDismiss()
            }
        }
    }
}

extension ActionMenuPlanDevelopingView {
    enum ScreenState {
        case addiction, plan, info
    }
}
