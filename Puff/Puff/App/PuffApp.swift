//
//  PuffApp.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import SwiftUI
import StoreKit

@main
struct PuffApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject var navigationVM = NavigationViewModel()
    @StateObject var onboardingVM = OnboardingViewModel()
    @StateObject var smokesManager = SmokesManager()
    @StateObject var reviewManager = ReviewManager()
    @StateObject var subscriptionsManager = SubscriptionsManager()
    @StateObject var appManager = AppManager()

    var body: some Scene {
        WindowGroup {
            StatusBarWrapperView {
                MainNavigationView(
                    navigationVM: navigationVM,
                    smokesManager: smokesManager,
                    onboardingVM: onboardingVM,
                    reviewManager: reviewManager,
                    subscriptionsManager: subscriptionsManager,
                    requestReview: requestReview
                )
            }
            .ignoresSafeArea(.keyboard)
            .preferredColorScheme(.light)
            .makeCustomSheet(isPresented: $navigationVM.shouldShowPlanDevelopingActionMenu) {
                ActionMenuPlanDevelopingView(todaySmokes: smokesManager.todaySmokes) {
                    smokesManager.startPlan(period: $0, smokesPerDay: $1)
                } onDismiss: {
                    navigationVM.shouldShowPlanDevelopingActionMenu.toggle()
                }
            }
            .makeCustomSheet(
                isPresented: $navigationVM.shouldShowReadyToBreakActionMenu,
                ableToDismissWithSwipe: false
            ) {
                ActionMenuReadyToBreakView(
                    tappedReadyToBreak: navigationVM.tappedReadyToBreak,
                    isLastSmoke: smokesManager.todaySmokes >= smokesManager.todayLimit,
                    todayLimit: smokesManager.todayLimit
                ) {
                    navigationVM.selectedTab = .home
                    smokesManager.endPlan()
                } onNeedOneMoreDay: {
                    smokesManager.addDay()
                } onDismiss: {
                    navigationVM.shouldShowReadyToBreakActionMenu = false
                    navigationVM.tappedReadyToBreak = false
                } onTappedWowButton: {
                    delay(0.5) { requestReview() }
                }
            } onDismiss: {
                navigationVM.shouldShowReadyToBreakActionMenu = false
                navigationVM.tappedReadyToBreak = false
            }
            .makeCustomSheet(isPresented: $navigationVM.shouldShowAddingMoreSmokesActionMenu) {
                ActionMenuAddingMoreSmokesView(onAddedMoreSmokes: smokesManager.addMoreSmokes) {
                    navigationVM.shouldShowAddingMoreSmokesActionMenu = false
                }
            }
            .makeCustomSheet(isPresented: $navigationVM.shouldShowPlanExtendingActionMenu) {
                ActionMenuYesterdayPlanExceededView(
                    todayLimit: smokesManager.todayLimit,
                    yesterdayLimit: smokesManager.yesterdayLimit,
                    yesterdedExceed: smokesManager.yesterdayCount - smokesManager.yesterdayLimit,
                    daysToEnd: smokesManager.daysInPlan - smokesManager.currentDayIndex - 1
                ) {
                    smokesManager.extendPlanForOneDay()
                } onDismiss: {
                    seenYesterdayResult()
                }
            } onDismiss: {
                seenYesterdayResult()
            }
            .makeCustomSheet(isPresented: $navigationVM.shouldShowYesterdayResult) {
                ActionMenuYesterdaySuccessedView(
                    daysToEnd: smokesManager.daysInPlan - smokesManager.currentDayIndex - 1,
                    todayLimit: smokesManager.todayLimit
                ) {
                    yesterdaySuccessedDismissAction()
                }
            } onDismiss: {
                yesterdaySuccessedDismissAction()
            }
            .makeCustomSheet(isPresented: $navigationVM.shouldShowUpdateActionMenu) {
                ActionMenuUpdateAppView {
                    navigationVM.seenUpdateActionMenu()
                }
            } onDismiss: {
                navigationVM.seenUpdateActionMenu()
            }
            .makeCustomSheet(isPresented: $navigationVM.shouldShowWidgetsTip) {
                ActionMenuWidgetsTipView {
                    navigationVM.showWidgetsInfo()
                    navigationVM.shouldShowWidgetsTip = false
                } onDismiss: {
                    navigationVM.shouldShowWidgetsTip = false
                }
            }
            .task {
                await subscriptionsManager.updatePurchasedProducts()
            }
            .onReceive(
                NotificationCenter.default.publisher(
                    for: UIApplication.didReceiveMemoryWarningNotification,
                    object: nil
                )
            ) { notification in
                CrashlyticsManager.log("OOM: \(notification)")
            }
        }
    }

    private func requestReview() {
        if let scene = UIApplication.shared
            .connectedScenes
            .first(
                where: { $0.activationState == .foregroundActive }
            ) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }

    private func seenYesterdayResult() {
        navigationVM.seenYesterdayResult()

        if smokesManager.currentDayIndex == 4 {
            if !reviewManager.hasSeenReviewRequestOn5Day {
                requestReview()
                reviewManager.hasSeenReviewRequestOn5Day = true
            }
        }
    }

    private func showPaywall() {
        navigationVM.shouldShowPaywall = true
    }

    private func yesterdaySuccessedDismissAction() {
        seenYesterdayResult()

        if !reviewManager.hasSeenReviewRequestAfterFirstSuccessDay {
            delay(0.4) { requestReview() }
            reviewManager.hasSeenReviewRequestAfterFirstSuccessDay = true
        }
    }
}
