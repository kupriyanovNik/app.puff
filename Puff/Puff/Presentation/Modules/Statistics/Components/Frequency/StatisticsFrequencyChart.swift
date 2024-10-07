//
//  StatisticsFrequencyChart.swift
//  Puff
//
//  Created by Никита Куприянов on 05.10.2024.
//

import SwiftUI

struct StatisticsFrequencyChart: View {

    @ObservedObject var statisticsFrequencyViewModel: StatisticsFrequencyViewModel
    @ObservedObject var smokesManager: SmokesManager

    var spacingBetweenChartCells: CGFloat = 3.5
    var chartCellHeight: CGFloat = 100

    private let calendar = Calendar.current

    private var isFirstDay: Bool {
        statisticsFrequencyViewModel.smokesHours.reduce(0, +) == smokesManager.todaySmokes
    }

    private var biggestValue: Int {
        statisticsFrequencyViewModel.smokesHours.max() ?? 500
    }

    private var activePeriodText: String {
        if smokesManager.smokesCount.isEmpty { return "–" }

        if isFirstDay, let index = statisticsFrequencyViewModel.smokesHours.firstIndex(of: biggestValue) {
            return "\(index):00"
        }

        if (statisticsFrequencyViewModel.smokesHours.filter { $0 != 0 }.count < 5),
            let index = statisticsFrequencyViewModel.smokesHours.firstIndex(of: biggestValue) {
            return "\(index):00"
        }

        return getActiveRange()
    }

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 10) {
                HStack(spacing: 3) {
                    Image(.statisticsFrequency)
                        .resizable()
                        .scaledToFit()
                        .frame(18)

                    Text("StatisticsFrequency.Title".l)
                        .font(.semibold14)
                        .foregroundStyle(Palette.accentColor)
                        .contentTransition(.identity)

                    Spacer()
                }

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(activePeriodText)
                            .font(.bold22)
                            .foregroundStyle(Palette.darkBlue)
                            .contentTransition(.identity)

                        Text("StatisticsFrequency.Description".l)
                            .font(.medium12)
                            .foregroundStyle(Palette.textQuaternary)
                    }


                    Spacer()
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
    }

    @ViewBuilder
    private func chartView() -> some View {
        HStack(spacing: 7) {
            VStack(spacing: 10) {
                GeometryReader { proxy in
                    let size = proxy.size
                    let startIndex = getActiveRangeStartIndex()

                    let widthOfBar: Double = ((size.width - (23 * spacingBetweenChartCells))) / 24.0
                    let summaryRectangleWidth: Double = (4 * spacingBetweenChartCells) + (5 * widthOfBar) + 5
                    let summaryRectangleOffset: Double = (Double(startIndex - 1) * spacingBetweenChartCells) + (Double(startIndex) * widthOfBar) - ((spacingBetweenChartCells + widthOfBar) * 2) - 5

                    HStack(spacing: spacingBetweenChartCells) {
                        ForEach(statisticsFrequencyViewModel.smokesHours.indices) { index in
                            let value = statisticsFrequencyViewModel.smokesHours[index]

                            Group {
                                if value == 0 {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(hex: 0xEFEFEF))
                                        .height(6)
                                        .vBottom()
                                } else {
                                    let height = (max(0, Double(value - 6)) / Double(max(1, biggestValue))) * size.height + 6

                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(hex: 0xB5D9FF))
                                        .height(height)
                                        .vBottom()
                                }
                            }
                        }
                    }
                    .background {
                        VStack {
                            Rectangle()
                                .fill(Color(hex: 0xEFEFEF))
                                .height(1)

                            Spacer()

                            Rectangle()
                                .fill(Color(hex: 0xEFEFEF))
                                .height(1)

                            Spacer()

                            Rectangle()
                                .fill(Color(hex: 0xEFEFEF))
                                .height(1)
                        }
                        .padding(.trailing, 3)
                    }
                    .background {
                        HStack {
                            Spacer()

                            Rectangle()
                                .fill(Color(hex: 0xEFEFEF))
                                .width(1)

                            Spacer()

                            Rectangle()
                                .fill(Color(hex: 0xEFEFEF))
                                .width(1)

                            Spacer()

                            Rectangle()
                                .fill(Color(hex: 0xEFEFEF))
                                .width(1)

                            Spacer()
                        }
                    }
                    .background {
                        if !isFirstDay {
                            if statisticsFrequencyViewModel.smokesHours.filter({ $0 != 0 }).count > 4 {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(hex: 0xB5D9FF, alpha: 0.28))
                                    .frame(width: summaryRectangleWidth)
                                    .hLeading()
                                    .offset(x: summaryRectangleOffset + summaryRectangleWidth / 2 - 2)
                            }
                        }
                    }
                }
                .height(chartCellHeight)

                xMarks()
            }

            yMarks()
        }
    }

    @ViewBuilder
    private func xMarks() -> some View {
        let keys: [String] = [
            (calendar.date(bySettingHour: 0, minute: 0, second: 0, of: .now) ?? .now).formatted(date: .omitted, time: .shortened),
            (calendar.date(bySettingHour: 7, minute: 0, second: 0, of: .now) ?? .now).formatted(date: .omitted, time: .shortened),
            (calendar.date(bySettingHour: 13, minute: 0, second: 0, of: .now) ?? .now).formatted(date: .omitted, time: .shortened),
            (calendar.date(bySettingHour: 19, minute: 0, second: 0, of: .now) ?? .now).formatted(date: .omitted, time: .shortened)
        ]

        HStack {
            ForEach(keys, id: \.self) { key in
                Text(key)
                    .font(.medium11)
                    .foregroundStyle(Palette.textQuaternary)
                    .padding(.vertical, 2)

                Spacer()
            }
        }
    }

    @ViewBuilder
    private func yMarks() -> some View {
        VStack {
            Text("\(biggestValue == 0 ? 500 : biggestValue)")
                .offset(y: -6)

            Spacer()

            Text("\(biggestValue == 0 ? 250 : Int(biggestValue / 2))")
                .offset(y: -2)

            Spacer()

            Text("0")
        }
        .font(.medium11)
        .width(27)
        .foregroundStyle(Palette.textQuaternary)
        .padding(.bottom, 26)
    }

    private func getActiveRangeStartIndex() -> Int {
        var maxSum = Int.min
        var startIndex = 0

        let arr = statisticsFrequencyViewModel.smokesHours

        for i in 0...(arr.count - 5) {
            let currentSum = arr[i] + arr[i + 1] + arr[i + 2] + arr[i + 3] + arr[i + 4]

            if currentSum > maxSum {
                maxSum = currentSum
                startIndex = i
            }
        }

        return startIndex
    }

    private func getActiveRange() -> String {
        let startIndex = getActiveRangeStartIndex()

        return "\(startIndex):00 - \(startIndex + 4):00"
    }
}

#Preview {
    StatisticsFrequencyChart(
        statisticsFrequencyViewModel: .init(),
        smokesManager: .init()
    )
}
