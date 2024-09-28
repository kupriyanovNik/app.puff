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

    @State private var isUserPremium = SubscriptionManager.shared.isPremium

    var body: some View {
        CircledTopCornersView(content: viewContent)
            .onChange(of: onboardingVM.hasSeenOnboarding) { _ in
                checkUserStatus()
            }
            .onChange(of: navigationVM.shouldShowPaywall) { _ in
                checkUserStatus()
            }
    }

    @ViewBuilder
    private func viewContent() -> some View {
        VStack(spacing: 10) {
            AppHeaderView(title: "Главная", navigationVM: navigationVM)

            planView()

            if !smokesManager.isPlanEnded {
                HomeViewTodaySmokesView(smokesManager: smokesManager, isUserPremium: $isUserPremium)

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
            if !isUserPremium {
                HomeViewIsNotPremiumPlanView {
                    navigationVM.shouldShowPaywall.toggle()
                }
            } else if !smokesManager.isPlanCreated {
                HomeViewIsPremiumPlanNotCreatedView {
                    navigationVM.shouldShowPlanDevelopingActionMenu.toggle()
                }
            } else if smokesManager.isPlanEnded {
                HomeViewIsPremiumPlanEnded {
                    navigationVM.shouldShowPlanDevelopingActionMenu.toggle()
                }
            } else {
                HomeViewIsPremiumPlanCreatedView(smokesManager: smokesManager) {
                    navigationVM.shouldShowReadyToBreakActionMenu.toggle()
                }
            }
        }
    }

    private func checkUserStatus() {
        animated {
            isUserPremium = SubscriptionManager.shared.isPremium
        }
    }
}

#Preview {
    HomeView(
        navigationVM: .init(),
        smokesManager: .init(),
        onboardingVM: .init()
    )
}
