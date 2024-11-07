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

    @Environment(\.requestReview) var requestReview

    var body: some Scene {
        WindowGroup {
            StatusBarWrapperView {
                MainNavigationView(
                    navigationVM: navigationVM,
                    smokesManager: smokesManager,
                    onboardingVM: onboardingVM
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

                    delay(0.4) { requestReview() }
                } onNeedOneMoreDay: {
                    smokesManager.addDay()
                } onDismiss: {
                    navigationVM.shouldShowReadyToBreakActionMenu = false
                    navigationVM.tappedReadyToBreak = false
                }
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
                    yesterdedExceed: smokesManager.yesterdayCount - smokesManager.yesterdayLimit
                ) {
                    smokesManager.extendPlanForOneDay()
                } onDismiss: {
                    navigationVM.seenYesterdayResult()
                }
            }
            .makeCustomSheet(isPresented: $navigationVM.shouldShowYesterdayResult) {
                ActionMenuYesterdaySuccessedView(todayLimit: smokesManager.todayLimit) {
                    navigationVM.seenYesterdayResult()

                    delay(0.4) { requestReview() }
                }
            }
            .onChange(of: smokesManager.todaySmokes) { newValue in
                if newValue == smokesManager.todayLimit && (smokesManager.isLastDayOfPlan) {
                    navigationVM.shouldShowReadyToBreakActionMenu = true
                }
            }
            .onAppear {
                if smokesManager.isDayAfterPlanEnded || (smokesManager.todaySmokes == smokesManager.todayLimit) {
                    navigationVM.shouldShowReadyToBreakActionMenu = true
                }

                if navigationVM.ableToShowYesterdayResult {
                    if smokesManager.isYesterdayLimitExceeded {
                        navigationVM.shouldShowPlanExtendingActionMenu = true
                    } else {
                        navigationVM.shouldShowYesterdayResult = true
                    }
                }
            }
            .onChange(of: smokesManager.todaySmokes) { newValue in
                if smokesManager.isTodayLimitExceeded && [0, 1].contains(smokesManager.currentDayIndex) {
                    navigationVM.shouldShowAddingMoreSmokesActionMenu = true
                }
            }
        }
    }
}
