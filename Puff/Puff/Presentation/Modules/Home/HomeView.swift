//
//  HomeView.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import SwiftUI
import UIKit
import Combine

struct HomeView: View {

    @ObservedObject var navigationVM: NavigationViewModel
    @ObservedObject var smokesManager: SmokesManager
    @ObservedObject var onboardingVM: OnboardingViewModel
    @ObservedObject var subscriptionsManager: SubscriptionsManager

    var body: some View {
        CircledTopCornersView(content: viewContent)
            .onAppear(perform: smokesManager.checkIsNewDay)
            .onChange(of: smokesManager.isPlanEnded) { newvalue in
                if newvalue {
                    NotificationManager.shared.removeAllNotifications()
                }
            }
    }

    @ViewBuilder
    private func viewContent() -> some View {
        VStack(spacing: 10) {
            AppHeaderView(title: "TabBar.Home".l, navigationVM: navigationVM)
                .onTapGesture(count: 5) {
                    onboardingVM.hasSeenOnboarding = false
                }

            planView()

            if !smokesManager.isPlanEnded {
                HomeViewTodaySmokesView(smokesManager: smokesManager)

                HomeViewSmokeButton(smokesManager: smokesManager)
            } else {
                HomeViewPlanEnded(smokesManager: smokesManager)
            }
        }
        .padding(.horizontal, 12)
    }

    @ViewBuilder
    private func planView() -> some View {
        Group {
            if !subscriptionsManager.isPremium {
                HomeViewIsNotPremiumPlanView {
                    navigationVM.shouldShowHomePaywall.toggle()
                    AnalyticsManager.logEvent(event: .openedPaywall(tab: 1))
                }
            } else if !smokesManager.isPlanStarted {
                HomeViewIsPremiumPlanNotCreatedView {
                    navigationVM.shouldShowPlanDevelopingActionMenu.toggle()
                }
            } else if smokesManager.isPlanEnded {
                HomeViewIsPremiumPlanEnded {
                    navigationVM.shouldShowPlanDevelopingActionMenu.toggle()
                }
            } else {
                HomeViewIsPremiumPlanCreatedView(smokesManager: smokesManager) {
                    navigationVM.tappedReadyToBreak = true
                    navigationVM.shouldShowReadyToBreakActionMenu = true
                }
            }
        }
    }
}

#Preview {
    HomeView(
        navigationVM: .init(),
        smokesManager: .init(),
        onboardingVM: .init(),
        subscriptionsManager: .init()
    )
}
