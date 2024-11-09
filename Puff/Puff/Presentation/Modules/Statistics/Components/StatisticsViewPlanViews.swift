//
//  StatisticsViewPlanViews.swift
//  Puff
//
//  Created by Никита Куприянов on 29.09.2024.
//

import SwiftUI

extension StatisticsView {
    struct StatisticsViewNotPremiumPlanView: View {

        @ObservedObject var navigationVM: NavigationViewModel

        var body: some View {
            DelayedButton {
                navigationVM.shouldShowStatisticsPaywall.toggle()
                AnalyticsManager.logEvent(event: .openedPaywall(tab: 2))
            } content: {
                VStack(spacing: 36) {
                    HStack(spacing: 12) {
                        Text("Statistics.StartYourQuitPlan".l)
                            .font(.semibold22)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .foregroundStyle(.white)
                            .padding([.leading, .top], 16)
                            .hLeading()

                        Text("Premium")
                            .font(.semibold16)
                            .foregroundStyle(Palette.textPrimary)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 10)
                            .background {
                                Capsule()
                                    .fill(.white)
                            }
                            .padding([.top, .trailing], 20)
                            .vTop()
                    }

                    HStack(spacing: 18) {
                        Image(.statisticsPlan)
                            .resizable()
                            .scaledToFit()
                            .frame(18)
                            .padding(.trailing, -15)

                        Text("Statistics.QuitPlan".l)

                        Image(.statisticsStatistics)
                            .resizable()
                            .scaledToFit()
                            .frame(18)
                            .padding(.trailing, -15)

                        Text("Statistics.DetailedStatistics".l)
                            .hLeading()

                    }
                    .font(.semibold14)
                    .foregroundStyle(.white.opacity(0.56))
                    .lineLimit(1)
                    .padding([.leading, .bottom], 16)
                }
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Palette.darkBlue)
                }
            }

        }
    }
}
