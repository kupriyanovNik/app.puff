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

    @State private var screenHeight: CGFloat = 500

    private let minSmokesCount: Int = 100
    private let maxSmokesCount: Int = 1000

    private var smokesCount: Int {
        HapticManager.onTabChanged()

        return 10 * Int(round(Double(maxSmokesCount - minSmokesCount) * (sliderPercentage / 100) / 10.0)) + 100
    }

    var body: some View {
        VStack(spacing: 32) {
            switch screenState {
            case .addiction:
                addictionView()
                    .transition(
                        .asymmetric(
                            insertion: .opacity,
                            removal: .opacity
                        ).animation(.easeInOut(duration: 0.3))
                    )
            case .plan:
                VStack(spacing: 32) {
                    ActionMenuPlanDevelopingPeriodPicker(selectedOption: $selectedPeriod)
                        .transition(
                            .asymmetric(
                                insertion: .opacity.animation(.easeInOut(duration: 0.3).delay(0.3)),
                                removal: .opacity
                            ).animation(.easeInOut(duration: 0.3))
                        )

                    AccentButton(text: "Далее", action: nextAction)
                        .padding(.horizontal, 16)
                        .padding(.top, 24)
                        .transition(.identity)
                }
            case .info:
                Text("выбранный план").makeSlideTransition()
            }
        }
        .fixedSize(horizontal: false, vertical: true)
//        .safeAreaInset(edge: .bottom) {
//            AccentButton(text: "Далее", action: nextAction)
//                .padding(.horizontal, 16)
//        }
        .padding(.top, 30)
        .presentationDragIndicator(.visible)
        .overlay {
            GeometryReader { geometry in
                Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
            }
        }
        .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
            delay(0.4) {
                    screenHeight = newHeight
            }
        }
        .presentationDetents([.height(screenHeight)])
        .animation(.smooth, value: screenHeight)
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

                ActionMenuPlanDevelopingSlider(percentage: $sliderPercentage)
                    .padding(.horizontal, 40)
            }

            AccentButton(text: "Далее", action: nextAction)
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .transition(.identity)
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
            }
        }
    }
}

#Preview {
    ActionMenuPlanDevelopingView()
}

extension ActionMenuPlanDevelopingView {
    enum ScreenState {
        case addiction, plan, info
    }
}

struct InnerHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
