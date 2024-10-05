//
//  StatisticsMonthlyChart.swift
//  Puff
//
//  Created by Никита Куприянов on 17.10.2024.
//

import SwiftUI

struct StatisticsMonthlyChart: View {

    @ObservedObject var statisticsMVM: StatisticsMonthlyViewModel
    @ObservedObject var smokesManager: SmokesManager
    @ObservedObject var subscriptionsManager: SubscriptionsManager

    @State private var ableToChangeMonthToBackward: Bool = false
    @State private var ableToChangeMonthToForward: Bool = false

    @State private var text: String = "Затяжки, этот месяц"

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"

        return formatter
    }()

    private var monthSmokesText: String {
        if let selectedIndex = statisticsMVM.selectedIndex {
            let realValue: Int? = statisticsMVM.currentMonthRealValues[selectedIndex]
            let estimatedValue: Int? = statisticsMVM.currentMonthEstimatedValues[selectedIndex]

            if let realValue {
                return String(realValue)
            }

            return "0"
        }

        return String(statisticsMVM.currentMonthRealValues.compactMap { $0 }.reduce(0, +))
    }

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 10) {
                HStack(spacing: 3) {
                    Image(.statisticsCloud)
                        .resizable()
                        .scaledToFit()
                        .frame(18)

                    MarkdownText(
                        text: text,
                        markdowns: ["Затяжки,"],
                        foregroundColor: Palette.textQuaternary
                    )
                    .font(.semibold14)
                    .contentTransition(.identity)

                    Spacer()

                    if subscriptionsManager.isPremium && smokesManager.dateOfFirstSmoke != nil {
                        HStack(spacing: 15) {
                            changeMonthButton(future: false, isDisabled: !ableToChangeMonthToBackward)
                            changeMonthButton(future: true, isDisabled: !ableToChangeMonthToForward)
                        }
                    }
                }

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(monthSmokesText)
                            .font(.bold22)
                            .foregroundStyle(Palette.darkBlue)
                            .contentTransition(.identity)

                        Text("Затяжек")
                            .font(.medium12)
                            .foregroundStyle(Palette.textQuaternary)
                    }

                    Spacer()

                    Group {
                        if let limit = statisticsMVM.limitForSelectedIndex {
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("\(limit)")
                                    .font(.bold22)
                                    .foregroundStyle(Palette.darkBlue)
                                    .contentTransition(.identity)

                                Text("Лимит")
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
        .onChange(of: statisticsMVM.monthForDate) { _ in
            statisticsMVM.selectedIndex = nil
            checkAbilityToChangeWeek()
            setText()
        }
        .onChange(of: statisticsMVM.selectedIndex) { _ in
            statisticsMVM.checkCurrentLimit()
        }
        .onAppear {
            checkAbilityToChangeWeek()
        }
        .onChange(of: smokesManager.isPlanStarted) { _ in
            statisticsMVM.updateMonthValues()
            checkAbilityToChangeWeek()
        }
        .onChange(of: smokesManager.todaySmokes) { _ in
            statisticsMVM.updateMonthValues()
        }
    }

    @ViewBuilder
    private func chartView() -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                let symbols: [String] = {
                    var weekdaySymbols = Calendar(identifier: .iso8601).shortWeekdaySymbols
                    weekdaySymbols.append(weekdaySymbols.remove(at: weekdaySymbols.startIndex))

                    return weekdaySymbols.map { $0.prefix(2).capitalized }
                }()

                StatisticsMainChart(
                    keys: symbols,
                    realValues: $statisticsMVM.currentMonthRealValues,
                    estimatedValues: $statisticsMVM.currentMonthEstimatedValues,
                    selectedIndex: $statisticsMVM.selectedIndex,
                    spacingBetweenChartCells: 3
                )
            }
        }
    }

    @ViewBuilder
    private func changeMonthButton(future: Bool, isDisabled: Bool) -> some View {
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
                        statisticsMVM.monthForDate = Calendar.current.date(
                            byAdding: .month,
                            value: future ? 1 : -1,
                            to: statisticsMVM.monthForDate
                        ) ?? .now
                    }

                    print("MFD", statisticsMVM.monthForDate)
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

            ableToChangeMonthToBackward = date.startOfMonth < statisticsMVM.monthForDate.startOfMonth
            return
        }

        ableToChangeMonthToBackward = true
    }

    private func checkAbilityToChangeWeekToForward() {
        if let planStartDate = smokesManager.planStartDate {
            if let planEndingDate = Calendar.current.date(
                byAdding: .day,
                value: smokesManager.daysInPlan - 1,
                to: Date(timeIntervalSince1970: TimeInterval(planStartDate))
            ) {
                ableToChangeMonthToForward = planEndingDate.startOfMonth > statisticsMVM.monthForDate.startOfMonth
                return
            }
        } else {
            ableToChangeMonthToForward = false
            return
        }

        ableToChangeMonthToForward = true
    }

    private func setText()     {
        let date = statisticsMVM.monthForDate
        let startOfMonth = date.startOfMonth
        let endOfMonth = date.endOfMonth

        if Date().startOfMonth == startOfMonth {
            text = "Затяжки, этот месяц"
            return
        }

        text = "Затяжки, \(formatter.string(from: startOfMonth))–\(formatter.string(from: endOfMonth))"
    }
}

#Preview {
    StatisticsMonthlyChart(
        statisticsMVM: .init(),
        smokesManager: .init(),
        subscriptionsManager: .init()
    )
}
