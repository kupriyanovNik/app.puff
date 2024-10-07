//
//  StatisticsPlanDailyView.swift
//  Puff
//
//  Created by Никита Куприянов on 01.10.2024.
//

import SwiftUI

struct StatisticsPlanDailyView: View {

    @ObservedObject var smokesManager: SmokesManager

    @State private var selectedIndex: Int = 0

    private var todayIndex: Int {
        smokesManager.currentDayIndex
    }

    var body: some View {
        VStack(spacing: 17) {
            headerView()
                .padding(.top, 14)
                .padding(.leading, 18)

            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: 6) {
                        ForEach(0..<max(smokesManager.planLimits.count, smokesManager.realPlanDayIndex + 1)) { index in
                            dayCell(index: index, proxy: proxy)
                        }
                    }
                    .padding(.vertical, 3)
                    .padding(.horizontal, 18)
                }
                .scrollIndicators(.hidden)
                .onAppear { selectToday(proxy: proxy) }
            }

            bottomView()
                .padding(.horizontal, 18)
                .padding(.bottom, 20)
        }
        .background {
            Color.white
                .cornerRadius(22)
        }
    }

    @ViewBuilder
    private func headerView() -> some View {
        HStack(spacing: 3) {
            Image(.subscriptionBenefits1)
                .resizable()
                .scaledToFit()
                .frame(18)

            Text("Statistics.QuitPlan".l)
                .font(.semibold14)
                .foregroundStyle(Palette.textAccent)

            Spacer()
        }
    }

    @ViewBuilder
    private func bottomView() -> some View {
        let dayIndex = smokesManager.realPlanDayIndex
        let ratio = getRatio(for: dayIndex)

        let index = min(smokesManager.planCounts.count - 1, selectedIndex)

        let limit = smokesManager.planLimits[index]
        let count = smokesManager.planCounts[index]

        let percentage = 1.0 - (Double(smokesManager.planLimits[min(smokesManager.planLimits.count - 1, dayIndex)]) / Double(smokesManager.planLimits[0]))
        let showPercentage = percentage > 0 && ratio < 1

        let leadingText: String = {
            if selectedIndex == dayIndex {
                return "StatisticsDaily.TodaySmokes".l
            } else if selectedIndex > dayIndex {
                return "StatisticsDaily.LimitForFuture".l.formatByDivider(divider: "{number}", count: selectedIndex + 1)
            }

            return "StatisticsDaily.SmokesForDay".l.formatByDivider(divider: "{number}", count: selectedIndex + 1)
        }()

        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .bottom, spacing: 2) {
                    Group {
                        if selectedIndex > dayIndex {
                            Text("\(limit)").foregroundColor(Palette.darkBlue)
                        } else {
                            (
                                Text("\(count)").foregroundColor(Palette.darkBlue)
                                +
                                Text("/\(limit)").foregroundColor(Palette.textQuaternary)
                            )
                        }
                    }
                    .font(.bold22)
                }

                Text(leadingText)
                    .font(.medium12)
                    .foregroundStyle(Palette.textQuaternary)
            }

            Spacer()

            Group {
                if showPercentage {
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(alignment: .bottom, spacing: 2) {
                            Image(.statisticsPlanPercentage)
                                .resizable()
                                .scaledToFit()
                                .frame(18)

                            Text("\(Int(percentage * 100))%")
                                .font(.bold22)
                                .foregroundStyle(Palette.darkBlue)
                        }

                        Text("StatisticsDaily.FromStartOfPlan".l)
                            .font(.medium12)
                            .foregroundStyle(Palette.textQuaternary)
                    }
                }
            }
        }
    }

    private func getRatio(for index: Int) -> Double {
        let iindex = min(index, smokesManager.planLimits.count - 1)

        return Double(smokesManager.planCounts[iindex]) / Double(smokesManager.planLimits[iindex])
    }

    private func selectCell(at index: Int, proxy: ScrollViewProxy) {
        selectedIndex = index

        withAnimation {
            proxy.scrollTo(index, anchor: .center)
        }
    }

    private func selectToday(proxy: ScrollViewProxy) {
        selectedIndex = smokesManager.realPlanDayIndex

        proxy.scrollTo(selectedIndex, anchor: .center)
    }
}

#Preview {
    StatisticsPlanDailyView(smokesManager: .init())
}

extension StatisticsPlanDailyView {
    @ViewBuilder
    private func dayCell(index: Int, proxy: ScrollViewProxy) -> some View {
        Group {
            if index < smokesManager.currentDayIndex {
                pastCell(index: index, proxy: proxy)
            } else {
                futureAndTodayCell(index: index, proxy: proxy)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: selectedIndex)
    }

    @ViewBuilder
    private func pastCell(index: Int, proxy: ScrollViewProxy) -> some View {
        let successed = getRatio(for: index) <= 1
        let isSelected = index == selectedIndex

        let imageName = successed ? "statisticsDaySuccessedImage" : "statisticsDayFailedImage"
        let successedColor = isSelected ? Color(hex: 0x75B8FD) : Color(hex: 0xB5D9FF)
        let failedColor = isSelected ? Color(hex: 0xFF7D7D) : Color(hex: 0xFDB9BA)
        let color = successed ? successedColor : failedColor

        Circle()
            .fill(color)
            .frame(40)
            .overlay {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(24)
            }
            .contentShape(.circle)
            .id(index)
            .onTapGesture {
                selectCell(at: index, proxy: proxy)
            }
    }

    @ViewBuilder
    private func futureAndTodayCell(index: Int, proxy: ScrollViewProxy) -> some View {
        let ratio = getRatio(for: index)
        let isSelected = index == selectedIndex
        let successed = ratio <= 1

        let successedColor = isSelected ? Color(hex: 0x75B8FD) : Color(hex: 0xB5D9FF)
        let failedColor = isSelected ? Color(hex: 0xFF7D7D) : Color(hex: 0xFDB9BA)
        let color = successed ? successedColor : failedColor

        let realIndex = smokesManager.realPlanDayIndex
        let currIndex = smokesManager.currentDayIndex
        let daysInPlan = smokesManager.daysInPlan

        let text = (((index + 1) == daysInPlan) && realIndex != currIndex) ? "\(realIndex + 1)" : "\(index + 1)"

        Circle()
            .stroke(Color(hex: 0xEFEFEF), style: .init(lineWidth: 5))
            .frame(36)
            .overlay {
                if index <= todayIndex {
                    Circle()
                        .trim(from: 0, to: min(1, ratio))
                        .stroke(color, style: .init(lineWidth: 5, lineCap: .round))
                        .frame(35)
                        .rotationEffect(.degrees(-90))
                }
            }
            .overlay {
                Text(text)
                    .font(.semibold16)
                    .foregroundStyle(isSelected ? Palette.darkBlue : Palette.textQuaternary)
            }
            .contentShape(.circle)
            .id(index)
            .padding(.horizontal, 2)
            .onTapGesture {
                selectCell(at: index, proxy: proxy)
            }
    }
}
