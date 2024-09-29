//
//  HomeViewPlanViews.swift
//  Puff
//
//  Created by Никита Куприянов on 28.09.2024.
//

import SwiftUI

extension HomeView {
    struct HomeViewIsNotPremiumPlanView: View {

        var action: () -> Void

        var body: some View {
            DelayedButton(action: action) {
                HStack(spacing: 3) {
                    Image(.homeStartPlanCalendar)
                        .resizable()
                        .scaledToFit()
                        .frame(22)
                        .opacity(0.56)

                    Text("Начать план бросания")
                        .font(.semibold16)
                        .foregroundStyle(.white.opacity(0.56))

                    Spacer()

                    Text("Premium")
                        .font(.semibold16)
                        .foregroundStyle(Palette.textPrimary)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .background {
                            Capsule()
                                .fill(.white)
                        }
                }
                .padding(.leading, 16)
                .padding(.trailing, 10)
                .height(44)
                .background {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Palette.darkBlue)
                }
            }
        }
    }

    struct HomeViewIsPremiumPlanNotCreatedView: View {

        var action: () -> Void

        var body: some View {
            DelayedButton(action: action) {
                HStack(spacing: 3) {
                    Spacer()

                    Image(.homeStartPlanCalendar)
                        .resizable()
                        .scaledToFit()
                        .frame(22)

                    Text("Начать план бросания")
                        .font(.semibold16)
                        .foregroundStyle(.white)

                    Spacer()
                }
                .height(44)
                .background {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Palette.darkBlue)
                }
            }
        }
    }

    struct HomeViewIsPremiumPlanCreatedView: View {

        @ObservedObject var smokesManager: SmokesManager

        var action: () -> Void

        var body: some View {
            Group {
                if smokesManager.isLastDayOfPlan {
                    DelayedButton(action: action, content: content)
                } else {
                    content()
                }
            }
        }

        @ViewBuilder
        private func content() -> some View {
            HStack(spacing: 8) {
                baseView()

                if smokesManager.isLastDayOfPlan {
                    lastDayView()
                } else {
                    nonLastDayView()
                }
            }
            .padding(.horizontal, 10)
            .height(44)
            .background {
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(hex: 0xE7E7E7))
            }
        }

        @ViewBuilder
        private func baseView() -> some View {
            Text("\(smokesManager.todayLimit)")
                .font(.semibold16)
                .foregroundStyle(.white)
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
                .background {
                    Capsule()
                        .fill(Palette.darkBlue)
                }

            Text("Лимит сегодня")
                .font(.semibold16)
                .foregroundStyle(Palette.textTertiary)

            Spacer()
        }

        @ViewBuilder
        private func lastDayView() -> some View {
            Text("Я готов бросить")
                .font(.semibold14)
                .foregroundStyle(Palette.textPrimary)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background {
                    Capsule()
                        .fill(.white)
                }
        }

        @ViewBuilder
        private func nonLastDayView() -> some View {
            HStack(spacing: 8) {
                (
                    Text("День \(smokesManager.currentDayIndex + 1)")
                        .foregroundColor(Palette.textPrimary)
                    +
                    Text("/\(smokesManager.daysInPlan)")
                        .foregroundColor(Palette.textSecondary)
                )
                .font(.semibold14)

                Circle()
                    .stroke(Color(hex: 0xE7E7E7), style: .init(lineWidth: 4))
                    .overlay {
                        Circle()
                            .trim(
                                from: 0,
                                to: Double(smokesManager.currentDayIndex + 1) / Double(smokesManager.daysInPlan)
                            )
                            .stroke(Palette.textPrimary, style: .init(lineWidth: 4, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .animation(.smooth, value: smokesManager.currentDayIndex)
                    }
                    .frame(14)
                    .padding(.vertical, 6)
            }
            .padding(.horizontal, 10)
            .background {
                Capsule()
                    .fill(.white)
            }
        }
    }

    struct HomeViewIsPremiumPlanEnded: View {

        var startNewPlan: () -> Void

        var body: some View {
            DelayedButton(action: startNewPlan) {
                HStack(spacing: 3) {
                    Spacer()

                    Image(.homeStartPlanAgain)
                        .resizable()
                        .scaledToFit()
                        .frame(22)

                    Text("Начать план заново")
                        .font(.semibold16)
                        .foregroundStyle(.white)

                    Spacer()
                }
                .height(44)
                .background {
                    Capsule()
                        .fill(Palette.darkBlue)
                }
            }
        }
    }

    struct HomeViewPlanEnded: View {

        @ObservedObject var smokesManager: SmokesManager

        var withoutSmokingString: String {
            "1 минута"
        }

        var body: some View {
            Image(.homeViewPlanEnded)
                .resizable()
                .scaledToFill()
                .cornerRadius(28)
                .overlay {
                    Text(withoutSmokingString)
                        .font(.bold65)
                        .monospacedDigit()
                        .contentTransition(.identity)
                        .foregroundStyle(Palette.darkBlue)
                        .hCenter()
                        .overlay {
                            Text("Я не парю уже")
                                .font(.medium24)
                                .foregroundStyle(Palette.textTertiary)
                                .offset(y: -45)
                        }
                }
        }
    }
}
