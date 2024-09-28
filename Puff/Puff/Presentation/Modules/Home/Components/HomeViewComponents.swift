//
//  HomeViewComponents.swift
//  Puff
//
//  Created by Никита Куприянов on 27.09.2024.
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
                if smokesManager.isLastDay {
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

                if smokesManager.isLastDay {
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
            HStack(spacing: 4) {
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
                    }
                    .frame(20)
                    .padding(.vertical, 4)
            }
            .padding(.horizontal, 10)
            .background {
                Capsule()
                    .fill(.white)
            }
        }
    }
}

extension HomeView {
    struct HomeViewSmokeButton: View {

        @ObservedObject var smokesManager: SmokesManager

        private var fillColor: Color {
            smokesManager.isTodayLimitExceeded ? Color(hex: 0xFDB9B9) : Color(hex: 0xB5D9FF)
        }

        var body: some View {
            RoundedRectangle(cornerRadius: 28)
                .fill(fillColor)
                .overlay {
                    RadialGradient(
                        colors: [.white.opacity(0.8), .white.opacity(0.02)],
                        center: .center,
                        startRadius: 0,
                        endRadius: 200
                    )
                }
                .overlay {
                    Group {
                        if smokesManager.isTodayLimitExceeded {
                            Image(.homeSmokeExceededButton)
                                .resizable()
                        } else {
                            Image(.homeSmokeNonExceededButton)
                                .resizable()
                        }
                    }
                    .scaledToFit()
                    .frame(32)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 35)
                    .background {
                        Capsule()
                            .fill(.white)
                    }
                }
                .animation(.smooth, value: smokesManager.isTodayLimitExceeded)
                .onTapGesture {
                    smokesManager.puff()
                }
        }
    }

    struct HomeViewTodaySmokesView: View {

        @ObservedObject var smokesManager: SmokesManager

        @Binding var isUserPremium: Bool

        private var height: Double { isSmallDevice ? 250 : 350 }

        private var percentage: Double {
            if !isUserPremium { return 0 }
            return Double(smokesManager.todaySmokes) / Double(smokesManager.todayLimit)
        }

        private var multiplier: Double { min(1, percentage * extraOffsetMultiplier) }

        private var offset: Double { height * multiplier }

        private var extraOffsetMultiplier: Double { (height - 50) / height }


        var body: some View {
            RoundedRectangle(cornerRadius: 28)
                .fill(Color(hex: 0xE7E7E7))
                .height(self.height)
                .overlay {
                    Group {
                        if smokesManager.isTodayLimitExceeded {
                            Image(.homeViewSmokesCountExceeded)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Image(.homeViewSmokesCountNonExceeded)
                                .resizable()
                                .scaledToFill()
                        }
                    }
                    .frame(width: 500, height: (self.height) + 50 )
                    .offset(y: self.height - (50 * extraOffsetMultiplier))
                    .offset(y: -offset)
                    .animation(.smooth, value: offset)
                    .animation(.smooth, value: extraOffsetMultiplier)
                }
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .contentShape(RoundedRectangle(cornerRadius: 28))
                .overlay {
                    Text("\(smokesManager.todaySmokes)")
                        .font(isSmallDevice ? .bold90 : .bold108)
                        .monospacedDigit()
                        .contentTransition(.identity)
                        .foregroundStyle(Palette.darkBlue)
                        .hCenter()
                        .overlay {
                            Text("Затяжек")
                                .font(isSmallDevice ? .medium22 : .medium24)
                                .foregroundStyle(Palette.textTertiary)
                                .offset(y: -75)
                        }
                }
                .overlay(alignment: .bottom) {
                    Text(
                        smokesManager.dateOfLastSmoke == nil ? "Отметьте первую затяжку" : ""
                    )
                    .font(.semibold16)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 4)
                    .background {
                        Capsule()
                            .fill(Color(hex: 0x030303, alpha: 0.1))
                    }
                    .padding(.bottom, 20)
                }
                .animation(.smooth, value: smokesManager.isTodayLimitExceeded)
        }
    }
}
