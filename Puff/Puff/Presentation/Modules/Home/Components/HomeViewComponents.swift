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
            RoundedRectangle(cornerRadius: isSmallDevice ? 18 : 28)
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
//                .makeRippleEffect(at: .init(x: 0, y: 0), trigger: smokesManager.todaySmokes)
                .animation(.smooth, value: smokesManager.isTodayLimitExceeded)
        }

        private func buttonAction() {
            isButtonPressed = true

            smokesManager.puff()

            HapticManager.feedback(style: .light, intensity: 0.75)

            delay(0.15) {
                isButtonPressed = false
            }
        }
    }

    struct HomeViewTodaySmokesView: View {

        @ObservedObject var smokesManager: SmokesManager

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
            if (percentage >= 0 && percentage < 0.3) || !smokesManager.isPlanStarted {
                return [fillColor, fillColor, fillColor, endFillColor]
            } else if percentage >= 0.3 && percentage < 0.67 {
                return [fillColor, fillColor.opacity(0.93), endFillColor]
            }

            return [fillColor, endFillColor]
        }

        var body: some View {
            RoundedRectangle(cornerRadius: isSmallDevice ? 18 : 28)
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
                .clipShape(RoundedRectangle(cornerRadius: isSmallDevice ? 18 : 28))
                .contentShape(RoundedRectangle(cornerRadius: isSmallDevice ? 18 : 28))
                .overlay {
                    Text("\(smokesManager.todaySmokes)")
                        .font(isSmallDevice ? .bold90 : .bold108)
                        .transition(
                            .asymmetric(
                                insertion: .scale(scale: 1.025),
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
                .lineLimit(2, reservesSpace: false)
                .padding(.horizontal, 18)
                .padding(.vertical, 4)
                .background {
                    Capsule()
                        .fill(Color(hex: 0x030303, alpha: 0.1))
                }
                .padding(.bottom, isSmallDevice ? 14 : 20)
                .onReceive(timer) { _ in setTime() }
                .onChange(of: smokesManager.todaySmokes) { _ in setTime() }
                .onAppear { setTime() }
        }

        private func setTime() {
            if smokesManager.todayLimit == smokesManager.todaySmokes {
                text = "Вы достигли лимита на сегодня"
            } else if smokesManager.todayLimit + 1 == smokesManager.todaySmokes {
                text = "Лимит обновится в 00:00"
            } else {
                if let dateOfLastSmoke = smokesManager.dateOfLastSmoke {
                    text = getLastSmokeTimeString(for: dateOfLastSmoke)
                } else {
                    text = "Отметьте первую затяжку"
                }
            }
        }

        private func getLastSmokeTimeString(for dateInt: Int) -> String {
            let diff = Double(Date().timeIntervalSince1970) - Double(dateInt)

            let days = Int(diff / 86400)
            let hours = Int(diff / 3600)
            let minutes = Int(diff / 60)

            if Bundle.main.preferredLocalizations[0] == "ru" {
                return "Последняя: " + getLastSmokeTimeRussianString(days, hours, minutes)
            } else {
                if days != 0 {
                    if days == 1 {
                        return "Last one: 1 day ago"
                    } else if days < 31 {
                        return "Last one: \(days) days ago"
                    } else {
                        return "Last one: a long time ago"
                    }
                } else {
                    if hours != 0 {
                        if hours == 1 {
                            return "Last one: 1 hour ago"
                        } else {
                            return "Last one: \(hours) hours ago"
                        }
                    } else {
                        if minutes != 0 {
                            if minutes == 1 {
                                return "Last one: 1 minute ago"
                            } else {
                                return "Last one: \(minutes) minutes ago"
                            }
                        } else {
                            return "Last one: just now"
                        }
                    }
                }
            }
        }

        private func getLastSmokeTimeRussianString(_ days: Int, _ hours: Int, _ minutes: Int) -> String {
            if days != 0 {
                if days < 31 {
                    if days % 10 == 1 && days % 100 != 11 {
                        return "\(days) день назад"
                    } else if (days % 10 >= 2 && days % 10 <= 4) && !(days % 100 >= 12 && days % 100 <= 14) {
                        return "\(days) дня назад"
                    } else {
                        return "\(days) дней назад"
                    }
                } else {
                    return "Последняя: давно"
                }
            } else {
                if hours != 0 {
                    if hours % 10 == 1 && hours % 100 != 11 {
                        return "\(hours) час назад"
                    } else if (hours % 10 >= 2 && hours % 10 <= 4) && !(hours % 100 >= 12 && hours % 100 <= 14) {
                        return "\(hours) часа назад"
                    } else {
                        return "\(hours) часов назад"
                    }
                } else {
                    if minutes != 0 {
                        if minutes % 10 == 1 && minutes % 100 != 11 {
                            return "\(minutes) минуту назад"
                        } else if (minutes % 10 >= 2 && minutes % 10 <= 4) && !(minutes % 100 >= 12 && minutes % 100 <= 14) {
                            return "\(minutes) минуты назад"
                        } else {
                            return "\(minutes) минут назад"
                        }
                    } else {
                        return "только что"
                    }
                }
            }
        }
    }
}
