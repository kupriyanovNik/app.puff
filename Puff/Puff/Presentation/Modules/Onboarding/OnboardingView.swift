//
//  OnboardingView.swift
//  Puff
//
//  Created by Никита Куприянов on 19.09.2024.
//

import SwiftUI

struct OnboardingView: View {

    @ObservedObject var onboardingVM: OnboardingViewModel
    @ObservedObject var subscriptionsManager: SubscriptionsManager
    @ObservedObject var navigationVM: NavigationViewModel

    var body: some View {
        NavigationStack(path: $onboardingVM.onboardingPath) {
            OnboardingWelcomeScreen(onboardingVM: onboardingVM)
                .navigationDestination(for: Int.self) { index in
                    switch index {
                    case 1: OnboardingValuePropositionScreen(onboardingVM: onboardingVM)
                    case 2: OnboardingSurveyDescriptionScreen(onboardingVM: onboardingVM)
                    case 3: OnboardingSurveyScreen(onboardingVM: onboardingVM)
                    case 4: OnboardingPlanCreatingScreen(onboardingVM: onboardingVM)
                    case 5: OnboardingContractScreen(onboardingVM: onboardingVM)
//                    case 6: AppPaywallView(subscriptionsManager: subscriptionsManager) { onboardingVM.nextScreen() }
                    case 6: NotificationRequestView {
                        AnalyticsManager.logEvent(event: .acceptedNotifications)
                        navigationVM.shouldShowPaywall = true
                        onboardingVM.hasSeenOnboarding = true
                    }
                    default: EmptyView()
                    }
                }
        }
    }
}

#Preview {
    OnboardingView(
        onboardingVM: .init(),
        subscriptionsManager: .init(),
        navigationVM: .init()
    )
}
