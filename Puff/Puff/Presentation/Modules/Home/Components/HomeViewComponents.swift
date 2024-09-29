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
//                .makeRippleEffect(at: origin, trigger: smokesManager.todaySmokes)
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

            return min(1, Double(smokesManager.todaySmokes) / Double(smokesManager.todayLimit))
        }

        private var multiplier: Double { min(1, percentage * extraOffsetMultiplier) }

        private var offset: Double { height * multiplier }

        private var extraOffsetMultiplier: Double { (height - 100) / height }

        private var fillColor: Color {
            if smokesManager.todaySmokes < smokesManager.todayLimit ||
                !smokesManager.isPlanStarted {
                return Color(hex: 0xB5D9FF)
            }

            return smokesManager.isTodayLimitExceeded ? Color(hex: 0xFDB9B9) : Color(hex: 0x7DADF3)
        }

        private var endFillColor: Color {
            if smokesManager.todaySmokes == smokesManager.todayLimit {
                return Color(hex: 0xC7DEFF)
            }

            return (smokesManager.isTodayLimitExceeded && smokesManager.isPlanStarted) ? Color(hex: 0xFFDBDB) : Color(hex: 0xD8E4F0)
        }

        var gradientColors: [Color] {
            if (percentage > 0 && percentage < 0.3) || !smokesManager.isPlanStarted {
                return [fillColor, fillColor, fillColor, endFillColor]
            } else if percentage >= 0.3 && percentage < 0.67 {
                return [fillColor, fillColor.opacity(0.93), endFillColor]
            }

            return [fillColor, endFillColor]
        }

        var body: some View {
            RoundedRectangle(cornerRadius: 28)
                .fill(Color(hex: 0xE7E7E7))
                .height(self.height)
                .overlay {
                    Group {
                        Ellipse()
                            .fill(
                                LinearGradient(
                                    gradient: .init(
                                        colors: gradientColors
                                    ),
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .aspectRatio(2.5, contentMode: .fill)
                            .animation(.smooth, value: self.gradientColors)
                    }
                    .frame(width: 500, height: (self.height) + 100)
                    .offset(y: self.height - (100 * extraOffsetMultiplier))
                    .offset(y: -offset)
                    .animation(.easeInOut(duration: 0.15), value: offset)
                    .animation(.easeInOut(duration: 0.15), value: extraOffsetMultiplier)
                }
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .contentShape(RoundedRectangle(cornerRadius: 28))
                .overlay {
                    Text("\(smokesManager.todaySmokes)")
                        .font(isSmallDevice ? .bold90 : .bold108)
                        .transition(
                            .asymmetric(
                                insertion: .scale(scale: 1.045),
                                removal: .identity
                            )
                        )
                        .id(smokesManager.todaySmokes)
                        .animation(.easeInOut(duration: 0.15), value: smokesManager.todaySmokes)
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
                    HomeViewLastSmokeTimeView(smokesManager: smokesManager)
                }
                .animation(.smooth, value: smokesManager.isTodayLimitExceeded)
        }
    }

    struct HomeViewLastSmokeTimeView: View {

        @ObservedObject var smokesManager: SmokesManager

        let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()

        @State private var text: String = ""

        var body: some View {
            Text(text)
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
                .onReceive(timer) { _ in setTime() }
                .onChange(of: smokesManager.dateOfLastSmoke) { _ in setTime() }
                .onAppear { setTime() }
        }

        private func setTime() {
            if let dateOfLastSmoke = smokesManager.dateOfLastSmoke {
                text = getLastSmokeTimeString(for: dateOfLastSmoke)
            } else {
                text = "Отметьте первую затяжку"
            }
        }

        private func getLastSmokeTimeString(for date: Date) -> String {
            let diff = TimeInterval(Date() - date)

            print("date", date)

            let days = Int(diff / 86400)
            let hours = Int(diff / 3600)
            let minutes = Int(diff / 60)

            print("diff", diff)
            print("info", days, hours, minutes)

            return ""
        }
    }
}
