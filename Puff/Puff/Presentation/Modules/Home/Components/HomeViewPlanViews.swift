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

        var text: String = "Начать план бросания"

        var action: () -> Void

        var body: some View {
            DelayedButton(action: action) {
                HStack(spacing: 3) {
                    Spacer()

                    Image(.homeStartPlanCalendar)
                        .resizable()
                        .scaledToFit()
                        .frame(22)

                    Text(text)
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

        let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

        @State private var text: String = ""
        
        var body: some View {
            Image(.homeViewPlanEnded)
                .resizable()
                .scaledToFit()
                .cornerRadius(28)
                .overlay {
                    Text(text)
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
                .onReceive(timer) { _ in setTime() }
                .onChange(of: smokesManager.todaySmokes) { _ in setTime() }
                .onAppear { setTime() }
        }

        private func setTime() {
            if let dateOfLastSmoke = smokesManager.dateOfLastSmoke {
                text = getLastSmokeTimeString(for: dateOfLastSmoke)
            } else {
                text = "Очень давно"
            }
        }

        private func getLastSmokeTimeString(for dateInt: Int) -> String {
            let diff = Double(Date().timeIntervalSince1970) - Double(dateInt)

            let days = Int(diff / 86400)
            let hours = Int(diff / 3600)
            let minutes = Int(diff / 60)

            if Bundle.main.preferredLocalizations[0] == "ru" {
                return getLastSmokeTimeRussianString(days, hours, minutes)
            } else {
                if days != 0 {
                    if days == 1 {
                        return "1 day"
                    } else {
                        return "\(days) days"
                    }
                } else {
                    if hours != 0 {
                        if hours == 1 {
                            return "1 hour"
                        } else {
                            return "\(hours) hours"
                        }
                    } else {
                        if minutes == 1 || minutes == 0 {
                            return "1 minute"
                        } else {
                            return "\(minutes) minutes"
                        }
                    }
                }
            }
        }

        private func getLastSmokeTimeRussianString(_ days: Int, _ hours: Int, _ minutes: Int) -> String {
            if days != 0 {
                if days % 10 == 1 && days % 100 != 11 {
                    return "\(days) день"
                } else if (days % 10 >= 2 && days % 10 <= 4) && !(days % 100 >= 12 && days % 100 <= 14) {
                    return "\(days) дня"
                } else {
                    return "\(days) дней"
                }
            } else {
                if hours != 0 {
                    if hours % 10 == 1 && hours % 100 != 11 {
                        return "\(hours) час"
                    } else if (hours % 10 >= 2 && hours % 10 <= 4) && !(hours % 100 >= 12 && hours % 100 <= 14) {
                        return "\(hours) часа"
                    } else {
                        return "\(hours) часов"
                    }
                } else {
                    if (minutes % 10 == 1 && minutes % 100 != 11) || minutes == 1 {
                        return "\(minutes) минуту"
                    } else if (minutes % 10 >= 2 && minutes % 10 <= 4) && !(minutes % 100 >= 12 && minutes % 100 <= 14) {
                        return "\(minutes) минуты"
                    } else {
                        return "\(minutes) минут"
                    }
                }
            }
        }
    }
}
