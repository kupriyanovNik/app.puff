//
//  StatisticsWeeklyChart.swift
//  Puff
//
//  Created by Никита Куприянов on 05.10.2024.
//

import SwiftUI

struct StatisticsWeeklyChart: View {

    @ObservedObject var statisticsWVM: StatisticsWeeklyViewModel
    @ObservedObject var smokesManager: SmokesManager
    @ObservedObject var subscriptionsManager: SubscriptionsManager

    @Binding var isScrollDisabled: Bool

    @State private var ableToChangeWeekToBackward: Bool = false
    @State private var ableToChangeWeekToForward: Bool = false

    @State private var text: String = "StatisticsWeekly.ThisWeek".l

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"

        return formatter
    }()

    private var weekSmokesText: String {
        if let selectedIndex = statisticsWVM.selectedIndex {
            let realValue: Int? = statisticsWVM.currentWeekRealValues[selectedIndex]

            if let realValue {
                return String(realValue)
            }

            return "0"
        }

        return String(statisticsWVM.currentWeekRealValues.compactMap { $0 }.reduce(0, +))
    }

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 6) {
                HStack(alignment: .top, spacing: 3) {
                    Image(.statisticsCloud)
                        .resizable()
                        .scaledToFit()
                        .frame(18)

                    MarkdownText(
                        text: text,
                        markdowns: ["Затяжки,", "Puffs"],
                        foregroundColor: Palette.textQuaternary
                    )
                    .font(.semibold14)
                    .contentTransition(.identity)

                    Spacer()

                    HStack(spacing: 15) {
                        changeWeekButton(future: false, isDisabled: !ableToChangeWeekToBackward)
                        changeWeekButton(future: true, isDisabled: !ableToChangeWeekToForward)
                    }
                    .opacity(subscriptionsManager.isPremium && smokesManager.dateOfFirstSmoke != nil ? 1 : 0)
                }

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(weekSmokesText)
                            .font(.bold22)
                            .foregroundStyle(Palette.darkBlue)
                            .contentTransition(.identity)

                        Text("Statistics.Puffs".l)
                            .font(.medium12)
                            .foregroundStyle(Palette.textQuaternary)
                    }


                    Spacer()

                    Group {
                        if let limit = statisticsWVM.limitForSelectedIndex {
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("\(limit)")
                                    .font(.bold22)
                                    .foregroundStyle(Palette.darkBlue)
                                    .contentTransition(.identity)

                                Text("Paywall.Limit".l)
                                    .font(.medium12)
                                    .foregroundStyle(Palette.textQuaternary)
                            }
                        }
                    }
                    .transition(.opacity.animation(.easeInOut(duration: 0.25)))
                }
            }

            chartView()
        }
        .padding([.leading, .vertical], 18)
        .padding(.trailing, 12)
        .background {
            Color.white
                .cornerRadius(22)
        }
        .onChange(of: statisticsWVM.weekForDate) { _ in
            statisticsWVM.selectedIndex = nil
            checkAbilityToChangeWeek()
            setText()
        }
        .onChange(of: statisticsWVM.selectedIndex) { _ in
            statisticsWVM.checkCurrentLimit()
        }
        .onAppear {
            checkAbilityToChangeWeek()
        }
        .onChange(of: smokesManager.isPlanStarted) { _ in
            statisticsWVM.updateWeekValues()
            checkAbilityToChangeWeek()
        }
        .onChange(of: smokesManager.todaySmokes) { _ in
            statisticsWVM.updateWeekValues()
        }
    }

    @ViewBuilder
    private func chartView() -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                let symbols: [String] = {
                    var weekdaySymbols = Calendar.current.shortWeekdaySymbols
                    weekdaySymbols.append(weekdaySymbols.remove(at: weekdaySymbols.startIndex))

                    return weekdaySymbols.map { $0.prefix(2).capitalized }
                }()

                StatisticsMainChart(
                    keys: symbols,
                    realValues: $statisticsWVM.currentWeekRealValues,
                    estimatedValues: $statisticsWVM.currentWeekEstimatedValues,
                    selectedIndex: $statisticsWVM.selectedIndex,
                    isScrollDisabled: $isScrollDisabled,
                    spacingBetweenChartCells: 6
                )
            }
        }
    }

    @ViewBuilder
    private func changeWeekButton(future: Bool, isDisabled: Bool) -> some View {
        Circle()
            .fill(Color(hex: 0xF6F6F6))
            .frame(30)
            .overlay {
                Image(.statisticsTimeDirection)
                    .resizable()
                    .scaledToFit()
                    .frame(18)
                    .rotationEffect(.degrees(future ? 0 : 180))
            }
            .opacity(isDisabled ? 0.5 : 1)
            .animation(.easeInOut(duration: 0.25), value: isDisabled)
            .onTapGesture {
                if !isDisabled {
                    withAnimation {
                        statisticsWVM.weekForDate = Calendar.current.date(
                            byAdding: .day,
                            value: future ? 7 : -7,
                            to: statisticsWVM.weekForDate
                        ) ?? .now
                    }
                }
            }
    }

    private func checkAbilityToChangeWeek() {
        checkAbilityToChangeWeekToBackward()
        checkAbilityToChangeWeekToForward()
    }

    private func checkAbilityToChangeWeekToBackward() {
        if let dateOfFirstSmoke = smokesManager.dateOfFirstSmoke {
            let date = Date(timeIntervalSince1970: TimeInterval(dateOfFirstSmoke))

            ableToChangeWeekToBackward = date.startOfWeek < statisticsWVM.weekForDate.startOfWeek
            return
        }

        ableToChangeWeekToBackward = true
    }

    private func checkAbilityToChangeWeekToForward() {
        if let planStartDate = smokesManager.planStartDate {
            if let planEndingDate = Calendar.current.date(
                byAdding: .day,
                value: smokesManager.daysInPlan - 1,
                to: Date(timeIntervalSince1970: TimeInterval(planStartDate))
            ) {
                ableToChangeWeekToForward = planEndingDate.startOfWeek > statisticsWVM.weekForDate.startOfWeek
                return
            }
        } else {
            ableToChangeWeekToForward = false
            return
        }

        ableToChangeWeekToForward = true
    }

    private func setText()     {
        let date = statisticsWVM.weekForDate
        let startOfWeek = date.startOfWeek
        let endOfWeek = date.endOfWeek

        if Date().startOfWeek == startOfWeek {
            text = "StatisticsWeekly.ThisWeek".l
            return
        }

        text = "Paywall.Puffs".l + ", \(formatter.string(from: startOfWeek))–\(formatter.string(from: endOfWeek))"
    }
}

#Preview {
    StatisticsWeeklyChart(
        statisticsWVM: .init(),
        smokesManager: .init(),
        subscriptionsManager: .init(),
        isScrollDisabled: .constant(false)
    )
}
