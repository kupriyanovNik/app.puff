//
//  MainNavigationView.swift
//  Puff
//
//  Created by Никита Куприянов on 19.09.2024.
//

import SwiftUI

struct MainNavigationView: View {

    @ObservedObject var navigationVM: NavigationViewModel
    @ObservedObject var smokesManager: SmokesManager
    @ObservedObject var onboardingVM: OnboardingViewModel
    @ObservedObject var reviewManager: ReviewManager
    @ObservedObject var subscriptionsManager: SubscriptionsManager

    var requestReview: () -> Void

    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()

            content()
                .safeAreaInset(edge: .bottom) {
                    TabBar(selectedTab: $navigationVM.selectedTab)
                }
        }
        .overlay {
            Group {
                if !onboardingVM.hasSeenOnboarding {
                    OnboardingView(onboardingVM: onboardingVM, subscriptionsManager: subscriptionsManager)
                        .preferredColorScheme(.light)
                        .transition(
                            .asymmetric(
                                insertion: .identity.animation(.none),
                                removal: .move(edge: .top).animation(.easeInOut(duration: 0.3))
                            )
                        )
                }
            }
            .animation(.easeInOut(duration: 0.3), value: onboardingVM.hasSeenOnboarding)
        }
        .overlay {
            Group {
                if navigationVM.shouldShowAccountView {
                    AccountView(
                        navigationVM: navigationVM,
                        smokesManager: smokesManager,
                        subscriptionsManager: subscriptionsManager
                    )
                    .preferredColorScheme(.light)
                    .transition(
                        .opacity.combined(with: .offset(y: 50))
                            .animation(.easeInOut(duration: 0.3))
                    )
                }
            }
            .animation(.easeInOut(duration: 0.3), value: navigationVM.shouldShowAccountView)
        }
        .overlay {
            Group {
                if navigationVM.shouldShowPaywall {
                    AppPaywallView(subscriptionsManager: subscriptionsManager, showBenefitsDelay: 0.4) {
                        navigationVM.shouldShowPaywall = false
                    }
                    .preferredColorScheme(.light)
                    .transition(
                        .opacity.combined(with: .offset(y: 50))
                        .animation(.easeInOut(duration: 0.3))
                    )
                }
            }
            .animation(.easeInOut(duration: 0.3), value: navigationVM.shouldShowPaywall)
        }
        .onChange(of: smokesManager.todaySmokes) { newValue in
            if newValue == 100 && !reviewManager.hasSeenReviewRequestAt100Smokes {
                requestReview()
                reviewManager.hasSeenReviewRequestAt100Smokes = true
            }

            if subscriptionsManager.isPremium {
                if smokesManager.isPlanStarted {
                    if newValue == smokesManager.todayLimit && (smokesManager.isLastDayOfPlan) {
                        navigationVM.shouldShowReadyToBreakActionMenu = true
                    }
                }
            }
        }
        .onChange(of: smokesManager.isPlanStarted) { newValue in
            handlePlanStarting(isStarted: newValue)
        }
        .onAppear {
            checkIsNowDayAfterEndOfPlan()

            handleYesterdayResult()
        }
        .onReceive(timer) { _ in
            checkIsNowDayAfterEndOfPlan()

            handleYesterdayResult()
        }
        .onChange(of: smokesManager.todaySmokes) { newValue in
            if subscriptionsManager.isPremium {
                if smokesManager.isPlanStarted && !smokesManager.isPlanEnded {
                    if smokesManager.isTodayLimitExceeded && [0, 1].contains(smokesManager.currentDayIndex) {
                        navigationVM.shouldShowAddingMoreSmokesActionMenu = true
                    }
                }
            }
        }
        .task {
            do {
                let response = try await UpdateManager().getLatestAvailableVersion()

                if let response {
                    if let actualVersion = response.version.components(separatedBy: ".").first {
                        if let appVersion = Bundle.main.appVersion.components(separatedBy: ".").first {
                            if (Int(actualVersion) ?? 0) > (Int(appVersion) ?? 0) {
                                if navigationVM.ableToShowUpdateActionMenu {
                                    navigationVM.shouldShowUpdateActionMenu = true
                                }
                            }
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    @ViewBuilder
    private func content() -> some View {
        switch self.navigationVM.selectedTab {
        case .home: HomeView(
            navigationVM: navigationVM,
            smokesManager: smokesManager,
            onboardingVM: onboardingVM,
            subscriptionsManager: subscriptionsManager
        )
        case .statistics: StatisticsView(
            navigationVM: navigationVM,
            smokesManager: smokesManager,
            subscriptionsManager: subscriptionsManager
        )
        }
    }

    private func handleYesterdayResult() {
        if subscriptionsManager.isPremium {
            if smokesManager.isPlanStarted && !smokesManager.isPlanEnded {
                navigationVM.checkAbilityToShowYesterdayResult()

                if navigationVM.ableToShowYesterdayResult && smokesManager.realPlanDayIndex == smokesManager.currentDayIndex {
                    if smokesManager.isYesterdayLimitExceeded {
                        navigationVM.shouldShowPlanExtendingActionMenu = true
                    } else if smokesManager.currentDayIndex > 0 {
                        navigationVM.shouldShowYesterdayResult = true
                    }
                }
            }
        }
    }

    private func checkIsNowDayAfterEndOfPlan() {
        if subscriptionsManager.isPremium {
            if smokesManager.isPlanStarted && !smokesManager.isPlanEnded {
                if smokesManager.isDayAfterPlanEnded || ((smokesManager.todaySmokes == smokesManager.todayLimit) && smokesManager.isLastDayOfPlan) {
                    navigationVM.shouldShowReadyToBreakActionMenu = true

                    navigationVM.selectedTab = .home
                }
            }
        }
    }
    
    private func handlePlanStarting(isStarted: Bool) {
        if isStarted {
            NotificationManager.shared.removeAllNotifications()
            NotificationManager.shared.scheduleNotifications(limits: smokesManager.planLimits)
        } else {
            NotificationManager.shared.removeAllNotifications()
        }
    }
}
