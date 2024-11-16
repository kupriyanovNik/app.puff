//
//  StatisticsView.swift
//  Puff
//
//  Created by Никита Куприянов on 19.09.2024.
//

import SwiftUI

struct StatisticsView: View {

    @ObservedObject var navigationVM: NavigationViewModel
    @ObservedObject var smokesManager: SmokesManager
    @ObservedObject var subscriptionsManager: SubscriptionsManager

    @StateObject var statisticsWVM = StatisticsWeeklyViewModel()
    @StateObject var statisticsMVM = StatisticsMonthlyViewModel()
    @StateObject var statisticsFVM = StatisticsFrequencyViewModel()

    @State private var isScrollDisabled: Bool = false

    var body: some View {
        CircledTopCornersView(content: viewContent)
    }

    @ViewBuilder
    private func viewContent() -> some View {
        VStack(spacing: 10) {
            AppHeaderView(title: "TabBar.Progress".l, navigationVM: navigationVM)

            ScrollView {
                VStack(spacing: 10) {
                    planView()

                    if smokesManager.isPlanStarted && !smokesManager.isPlanEnded && AdaptySubscriptionManager.shared.isPremium {
                        StatisticsPlanDailyView(smokesManager: smokesManager)
                    }

                    StatisticsWeeklyChart(
                        statisticsWVM: statisticsWVM,
                        smokesManager: smokesManager,
                        subscriptionsManager: subscriptionsManager,
                        isScrollDisabled: $isScrollDisabled
                    )

                    StatisticsMonthlyChart(
                        statisticsMVM: statisticsMVM,
                        smokesManager: smokesManager,
                        subscriptionsManager: subscriptionsManager,
                        isScrollDisabled: $isScrollDisabled
                    )

                    StatisticsFrequencyChart(
                        statisticsFrequencyViewModel: statisticsFVM,
                        smokesManager: smokesManager
                    )
                }
            }
            .scrollIndicators(.hidden)
            .scrollDisabled(isScrollDisabled)
        }
        .padding(.horizontal, 12)
    }

    @ViewBuilder
    private func planView() -> some View {
        if !subscriptionsManager.isPremium {
            StatisticsViewNotPremiumPlanView(navigationVM: navigationVM)
        } else if !smokesManager.isPlanStarted {
            HomeView.HomeViewIsPremiumPlanNotCreatedView {
                navigationVM.shouldShowPlanDevelopingActionMenu.toggle()
            }
        } else if smokesManager.isLastDayOfPlan && !smokesManager.isPlanEnded {
            HomeView.HomeViewIsPremiumPlanNotCreatedView(text: "Home.ReadyToQuit".l) {
                navigationVM.tappedReadyToBreak = true
                navigationVM.shouldShowReadyToBreakActionMenu = true
            }
        } else if smokesManager.isPlanEnded {
            HomeView.HomeViewIsPremiumPlanEnded {
                navigationVM.shouldShowPlanDevelopingActionMenu.toggle()
            }
        }
    }
}

#Preview {
    StatisticsView(
        navigationVM: .init(),
        smokesManager: .init(),
        subscriptionsManager: .init()
    )
}
