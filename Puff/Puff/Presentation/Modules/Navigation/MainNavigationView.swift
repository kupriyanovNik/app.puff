//
//  MainNavigationView.swift
//  Puff
//
//  Created by Никита Куприянов on 19.09.2024.
//

import SwiftUI
import WidgetKit

struct MainNavigationView: View {

    @ObservedObject var navigationVM: NavigationViewModel
    @ObservedObject var smokesManager: SmokesManager
    @ObservedObject var onboardingVM: OnboardingViewModel
    @ObservedObject var reviewManager: ReviewManager
    @ObservedObject var subscriptionsManager: SubscriptionsManager

    @State private var shouldShowCurrentDayIndexError: Bool = false

    @Environment(\.scenePhase) var scenePhase

    var requestReview: () -> Void

    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack(path: $navigationVM.appNavigationPath) {
            ZStack {
                Color.clear
                    .ignoresSafeArea()

                content()
                    .safeAreaInset(edge: .bottom) {
                        TabBar(selectedTab: $navigationVM.selectedTab)
                    }
            }
            .navigationDestination(for: String.self) { value in
                switch value {
                case AppNavigationPathValue.account: AccountView(
                    navigationVM: navigationVM,
                    smokesManager: smokesManager,
                    subscriptionsManager: subscriptionsManager
                ).prepareForStackPresentationInOnboarding()
                case AppNavigationPathValue.accountSubscriptionInfo: AccountView.AccountViewSubscriptionInfoView(
                    subscriptionsManager: subscriptionsManager,
                    backAction: navigationVM.back
                ).prepareForStackPresentationInOnboarding()
                case AppNavigationPathValue.accountWidgetsInfo: AccountViewWidgetsInfoView(
                    navigationVM: navigationVM
                ).prepareForStackPresentationInOnboarding()

                case AppNavigationPathValue.accountWidgetsInfoHomeScreen: AccountViewWidgetsInfoView(
                    navigationVM: navigationVM
                ).homeScreenInfoView().prepareForStackPresentationInOnboarding()

                case AppNavigationPathValue.accountWidgetsInfoControlCenter: AccountViewWidgetsInfoView(
                    navigationVM: navigationVM
                ).controlCenterInfoView().prepareForStackPresentationInOnboarding()

                case AppNavigationPathValue.accountWidgetsInfoActionButton: AccountViewWidgetsInfoView(
                    navigationVM: navigationVM
                ).actionButtonInfoView().prepareForStackPresentationInOnboarding()

                case AppNavigationPathValue.accountWidgetsInfoDoubleTap: AccountViewWidgetsInfoView(
                    navigationVM: navigationVM
                ).doubleBackTapInfoView().prepareForStackPresentationInOnboarding()

                case AppNavigationPathValue.accountWidgetsInfoLockScreen: AccountViewWidgetsInfoView(
                    navigationVM: navigationVM
                ).lockScreenInfoView().prepareForStackPresentationInOnboarding()

                default: EmptyView()
                }
            }
        }
        .alert(isPresented: $shouldShowCurrentDayIndexError) {
            Alert(title: Text("Home.CurrentDayIndexErrorText".l))
        }
        .makeCustomConditionalView(
            !onboardingVM.hasSeenOnboarding,
            transition: .asymmetric(
                insertion: .identity.animation(.none),
                removal: .move(edge: .top).animation(.mainAnimation)
            )
        ) {
            OnboardingView(
                onboardingVM: onboardingVM,
                subscriptionsManager: subscriptionsManager
            )
        }
        .makeCustomConditionalView(navigationVM.shouldShowPaywall) {
            AppPaywallView(subscriptionsManager: subscriptionsManager, showBenefitsDelay: 0.4) {
                navigationVM.shouldShowPaywall = false
            }
        }
        .onChange(of: smokesManager.todaySmokes) { newValue in
            if !navigationVM.hasSeenWidgetsTip {
                if newValue == 50 {
                    navigationVM.shouldShowWidgetsTip = true
                    navigationVM.hasSeenWidgetsTip = true
                }
            }

            if subscriptionsManager.isPremium {
                if smokesManager.isPlanStarted {
                    if newValue == smokesManager.todayLimit && (smokesManager.isLastDayOfPlan) {
                        navigationVM.shouldShowReadyToBreakActionMenu = true
                    }
                }
            }
        }
        .onChange(of: smokesManager.currentDayIndex) { newValue in
            navigationVM.shouldShowAddingMoreSmokesActionMenu = false
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
        .onChange(of: smokesManager.todaySmokes) { _ in
            openAddingMoreSmokesSheetIfNeeded()
        }
        .onAppear(perform: openAddingMoreSmokesSheetIfNeeded)
        .onChange(of: scenePhase) { newValue in
            if newValue == .active {
                smokesManager.restore()
            }
        }
        .task {
            if navigationVM.ableToShowUpdateActionMenu {
                do {
                    let response = try await UpdateManager().getLatestAvailableVersion()

                    handleNewVersion(response)
                } catch {
                    CrashlyticsManager.log(error.localizedDescription)
                }
            }
        }
        .onAppear {
            if smokesManager.isPlanStarted {
                if !defaults.bool(forKey: "newIsPlanStarted") {
                    defaults.set(true, forKey: "newIsPlanStarted")
                }
            }
        }
        .onAppear {
            if smokesManager.currentDayIndex < 0 {
                shouldShowCurrentDayIndexError = true
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

            WidgetCenter.shared.reloadAllTimelines()
        }
    }

    private func handleNewVersion(_ response: UpdateManager.LatestAppStoreVersion?) {
        if let response {
            let actualAppInfo = response.version.components(separatedBy: ".")
            let currentAppInfo = Bundle.main.appVersion.components(separatedBy: ".")

            if (actualAppInfo.count >= 2) && (currentAppInfo.count >= 2) {
                let actualAppVersion = Int(actualAppInfo[0]) ?? 0
                let actualAppBuild = Int(actualAppInfo[1]) ?? 0

                let currentAppVersion = Int(currentAppInfo[0]) ?? 0
                let currentAppBuild = Int(currentAppInfo[1]) ?? 0

                let isFutureVersion: Bool = actualAppVersion > currentAppVersion
                let isActualVersion: Bool = actualAppVersion == currentAppVersion

                if isFutureVersion || ((isActualVersion) && (actualAppBuild > currentAppBuild)) {
                    navigationVM.shouldShowUpdateActionMenu = true
                }
            }
        } else {
            print("DEBUG: unable to get UpdateManager.LatestAppStoreVersion response")
        }
    }

    private func openAddingMoreSmokesSheetIfNeeded() {
        if subscriptionsManager.isPremium {
            if smokesManager.isPlanStarted && !smokesManager.isPlanEnded {
                if smokesManager.isTodayLimitExceeded && [0, 1].contains(smokesManager.currentDayIndex) {
                    navigationVM.shouldShowAddingMoreSmokesActionMenu = true
                }
            }
        }
    }
}
