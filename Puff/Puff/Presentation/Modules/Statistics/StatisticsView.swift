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

    var body: some View {
        CircledTopCornersView(content: viewContent)
    }

    @ViewBuilder
    private func viewContent() -> some View {
        VStack(spacing: 10) {
            AppHeaderView(title: "Прогресс", navigationVM: navigationVM)

            ScrollView {
                planView()
            }
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal, 12)
    }

    @ViewBuilder
    private func planView() -> some View {
        if !SubscriptionManager.shared.isPremium {
            StatisticsViewNotPremiumPlanView(navigationVM: navigationVM)
        } else if !smokesManager.isPlanStarted {
            HomeView.HomeViewIsPremiumPlanNotCreatedView {
                navigationVM.shouldShowPlanDevelopingActionMenu.toggle()
            }
        } else if smokesManager.isLastDayOfPlan && !smokesManager.isPlanEnded {
            HomeView.HomeViewIsPremiumPlanNotCreatedView(text: "Я готов бросить") {
                navigationVM.shouldShowReadyToBreakActionMenu.toggle()
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
        smokesManager: .init()
    )
}
