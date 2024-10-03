//
//  HomeViewComponents.swift
//  Puff
//
//  Created by Никита Куприянов on 27.09.2024.
//

import SwiftUI

extension HomeView {
    struct HomeViewSmokeButton: View {

        @ObservedObject var smokesManager: SmokesManager

        @State private var isButtonPressed: Bool = false

        private var fillColor: Color {
            if smokesManager.todaySmokes < smokesManager.todayLimit ||
                !smokesManager.isPlanStarted {
                return Color(hex: 0xB5D9FF)
            }

            return smokesManager.isTodayLimitExceeded ? Color(hex: 0xFDB9B9) : Color(hex: 0x7DADF3)
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
                .opacity(isButtonPressed ? 0.7 : 1)
                .scaleEffect(isButtonPressed ? 0.99 : 1)
                .animation(.easeInOut(duration: 0.15), value: isButtonPressed)
                .overlay {
                    Group {
                        if smokesManager.isTodayLimitExceeded && smokesManager.isPlanStarted {
                            Image(.homeSmokeExceededButton)
                                .resizable()
                        } else if smokesManager.todaySmokes == smokesManager.todayLimit && smokesManager.isPlanStarted {
                            Image(.homeSmokeOnEdgeButton)
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
                .onTapGesture(perform: buttonAction)
                .animation(.smooth, value: smokesManager.isTodayLimitExceeded)
        }

        private func buttonAction() {
            isButtonPressed = true

            smokesManager.puff()

            delay(0.15) {
                isButtonPressed = false
            }
        }
    }

    struct HomeViewTodaySmokesView: View {

        @ObservedObject var smokesManager: SmokesManager

        @Binding var isUserPremium: Bool

        private var height: Double { isSmallDevice ? 250 : 350 }

        private var percentage: Double {
            if !smokesManager.isPlanStarted { return 0 }

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
                        if smokesManager.isTodayLimitExceeded && smokesManager.isPlanStarted {
                            Image(.homeViewSmokesCountExceeded)
                                .resizable()
                                .scaledToFill()
                        } else if smokesManager.todaySmokes == smokesManager.todayLimit && smokesManager.isPlanStarted {
                            Image(.homeViewSmokesCountOnEdge)
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
                    .animation(.easeInOut(duration: 0.15), value: offset)
                    .animation(.easeInOut(duration: 0.15), value: extraOffsetMultiplier)
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
