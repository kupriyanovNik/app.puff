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
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack(spacing: 6) {
                    
                }
            }
            .scrollIndicators(.hidden)
            .onAppear {
                selectToday(proxy: proxy)
            }
        }
    }

    @ViewBuilder
    private func pastCell(index: Int, proxy: ScrollViewProxy) -> some View {
        let successed = smokesManager.planCounts[index] <= smokesManager.planLimits[index]
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
        let text = (index + 1) == smokesManager.daysInPlan ? "\(smokesManager.realPlanDayIndex)" : "\(index + 1)"

        Circle()
            .stroke(Color(hex: 0xEFEFEF), style: .init(lineWidth: 5))
            .frame(40)
            .overlay {
                if index <= todayIndex {
                    Circle()
                        .trim(from: 0, to: ratio)
                        .stroke(Color(hex: 0xB5D9FF), style: .init(lineWidth: 5, lineCap: .round))
                        .frame(40)
                }
            }
            .overlay {
                Text(text)
                    .font(.semibold16)
                    .foregroundStyle(isSelected ? Palette.darkBlue : Palette.textQuaternary)
            }
            .contentShape(.circle)
            .id(index)
            .onTapGesture {
                selectCell(at: index, proxy: proxy)
            }
    }

    private func getRatio(for index: Int) -> Double {
        Double(smokesManager.smokesCount[index]) / Double(smokesManager.planLimits[index])
    }

    private func selectCell(at index: Int, proxy: ScrollViewProxy) {
        selectedIndex = index

        withAnimation {
            proxy.scrollTo(index)
        }
    }

    private func selectToday(proxy: ScrollViewProxy) {
        selectedIndex = smokesManager.currentDayIndex

        proxy.scrollTo(selectedIndex, anchor: .leading)
    }
}

#Preview {
    StatisticsPlanDailyView(smokesManager: .init())
}
