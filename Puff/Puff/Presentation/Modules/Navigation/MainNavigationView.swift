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

    var requestReview: () -> Void

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
                    OnboardingView(onboardingVM: onboardingVM)
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
                if navigationVM.shouldShowPaywall {
                    AppPaywallView(showBenefitsDelay: 0.4) {
                        navigationVM.shouldShowPaywall.toggle()
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
        .overlay {
            Group {
                if navigationVM.shouldShowAccountView {
                    AccountView(
                        navigationVM: navigationVM,
                        smokesManager: smokesManager
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
        .onChange(of: smokesManager.todaySmokes) { newValue in
            if newValue == 100 && !reviewManager.hasSeenReviewRequestAt100Smokes {
                requestReview()
                reviewManager.hasSeenReviewRequestAt100Smokes = true
            }

            if smokesManager.isPlanStarted {
                if newValue == smokesManager.todayLimit && (smokesManager.isLastDayOfPlan) {
                    navigationVM.shouldShowReadyToBreakActionMenu = true
                }
            }
        }
        .onAppear {
            if smokesManager.isPlanStarted {
                if smokesManager.isDayAfterPlanEnded || (smokesManager.todaySmokes == smokesManager.todayLimit) {
                    navigationVM.shouldShowReadyToBreakActionMenu = true
                }
            }

            if smokesManager.isPlanStarted {
                if navigationVM.ableToShowYesterdayResult && smokesManager.realPlanDayIndex == smokesManager.currentDayIndex {
                    if smokesManager.isYesterdayLimitExceeded {
                        navigationVM.shouldShowPlanExtendingActionMenu = true
                    } else {
                        navigationVM.shouldShowYesterdayResult = true
                    }
                }
            }
        }
        .onChange(of: smokesManager.todaySmokes) { newValue in
            if smokesManager.isPlanStarted {
                if smokesManager.isTodayLimitExceeded && [0, 1].contains(smokesManager.currentDayIndex) {
                    navigationVM.shouldShowAddingMoreSmokesActionMenu = true
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
            onboardingVM: onboardingVM
        )
        case .statistics: StatisticsView(
            navigationVM: navigationVM,
            smokesManager: smokesManager
        )
        }
    }
}

#Preview {
    MainNavigationView(
        navigationVM: .init(),
        smokesManager: .init(),
        onboardingVM: .init(),
        reviewManager: .init()
    ) { }
}
