//
//  StatisticsWeeklyChart.swift
//  Puff
//
//  Created by Никита Куприянов on 05.10.2024.
//

import SwiftUI

struct StatisticsWeeklyChart: View {

    @ObservedObject var statisticsVM: StatisticsViewModel

    @State private var selectedIndex: Int?

    var weekSmokesSumma: Int { statisticsVM.currentWeekRealValues.compactMap { $0 }.reduce(0, +) }

    var body: some View {
        VStack(spacing: 20) {
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
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("\(weekSmokesSumma)")
                    .font(.bold22)
                    .foregroundStyle(Palette.darkBlue)

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
}

#Preview {
    StatisticsWeeklyChart(statisticsVM: .init())
}
