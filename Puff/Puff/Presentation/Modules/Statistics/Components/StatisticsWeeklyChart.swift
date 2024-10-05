//
//  StatisticsWeeklyChart.swift
//  Puff
//
//  Created by Никита Куприянов on 05.10.2024.
//

import SwiftUI

struct StatisticsWeeklyChart: View {

    @ObservedObject var statisticsVM: StatisticsViewModel
    @ObservedObject var smokesManager: SmokesManager
    @ObservedObject var subscriptionsManager: SubscriptionsManager

    @State private var selectedIndex: Int?

    private var weekSmokesSumma: Int {
        statisticsVM.currentWeekRealValues.compactMap { $0 }.reduce(0, +)
    }

    @State private var ableToChangeWeekToBackward: Bool = false

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 3) {
                Image(.statisticsCloud)
                    .resizable()
                    .scaledToFit()
                    .frame(18)

                MarkdownText(
                    text: "Затяжки, эта неделя",
                    markdowns: ["Затяжки,"],
                    foregroundColor: Palette.textQuaternary
                )
                .font(.semibold14)

                Spacer()

                if subscriptionsManager.isPremium {
                    HStack(spacing: 15) {
                        changeMonthButton(future: false, isDisabled: !ableToChangeWeekToBackward)
                        changeMonthButton(future: true, isDisabled: false)

                    }
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("\(weekSmokesSumma)")
                    .font(.bold22)
                    .foregroundStyle(Palette.darkBlue)
                    .contentTransition(.identity)

                Text("Затяжек")
                    .font(.medium12)
                    .foregroundStyle(Palette.textQuaternary)
            }
            .hLeading()

            chartView()
        }
        .padding([.leading, .vertical], 18)
        .padding(.trailing, 12)
        .background {
            Color.white
                .cornerRadius(22)
        }
        .onChange(of: statisticsVM.weekForDate) { _ in
            selectedIndex = nil
            checkAbilityToChangeWeek()
        }
        .onAppear { checkAbilityToChangeWeek() }
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
                    realValues: $statisticsVM.currentWeekRealValues,
                    estimatedValues: $statisticsVM.currentWeekEstimatedValues,
                    selectedIndex: $selectedIndex,
                    spacingBetweenChartCells: 6
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
            .onTapGesture {
                if !isDisabled {
                    withAnimation {
                        statisticsVM.weekForDate = Calendar.current.date(
                            byAdding: .day,
                            value: future ? 7 : -7,
                            to: statisticsVM.weekForDate
                        ) ?? .now
                    }
                }
            }
    }

    private func checkAbilityToChangeWeek() {
        if let dateOfFirstSmoke = smokesManager.dateOfFirstSmoke {
            let date = Date(timeIntervalSince1970: TimeInterval(dateOfFirstSmoke))

            ableToChangeWeekToBackward = date.startOfWeek < statisticsVM.weekForDate.startOfWeek
            return
        }

        ableToChangeWeekToBackward = true
    }
}

#Preview {
    StatisticsWeeklyChart(
        statisticsVM: .init(),
        smokesManager: .init(),
        subscriptionsManager: .init()
    )
}
