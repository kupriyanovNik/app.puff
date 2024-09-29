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
                navigationVM.shouldShowPaywall.toggle()
            } content: {
                VStack(spacing: 36) {
                    HStack(spacing: 12) {
                        Text("Начните свой план бросания")
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
                    }

                    HStack(spacing: 18) {
                        Image(.statisticsPlan)
                            .resizable()
                            .scaledToFit()
                            .frame(18)
                            .padding(.trailing, -15)

                        Text("План бросания")

                        Image(.statisticsStatistics)
                            .resizable()
                            .scaledToFit()
                            .frame(18)
                            .padding(.trailing, -15)

                        Text("Детальная статистика")
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