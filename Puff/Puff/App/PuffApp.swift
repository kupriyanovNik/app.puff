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
                    navigationVM.seenYesterdayResult()
                }
            } onDismiss: {
                navigationVM.seenYesterdayResult()
            }
            .makeCustomSheet(isPresented: $navigationVM.shouldShowYesterdayResult) {
                ActionMenuYesterdaySuccessedView(
                    daysToEnd: smokesManager.daysInPlan - smokesManager.currentDayIndex - 1,
                    todayLimit: smokesManager.todayLimit
                ) {
                    navigationVM.seenYesterdayResult()

                    delay(0.4) { requestReview() }
                }
            } onDismiss: {
                navigationVM.seenYesterdayResult()

                delay(0.4) { requestReview() }
            }
            .makeCustomSheet(isPresented: $navigationVM.shouldShowUpdateActionMenu) {
                ActionMenuUpdateAppView {
                    navigationVM.seenUpdateActionMenu()
                }
            } onDismiss: {
                navigationVM.seenUpdateActionMenu()
            }
            .onChange(of: smokesManager.todaySmokes) { newValue in
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
    }
}
