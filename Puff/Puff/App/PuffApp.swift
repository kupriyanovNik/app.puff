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
                    tappedReadyToBreak: smokesManager.realPlanDayIndex - smokesManager.planCounts.count == -1,
                    isLastSmoke: smokesManager.todaySmokes == smokesManager.todayLimit,
                    todayLimit: smokesManager.todayLimit
                ) {
                    smokesManager.endPlan()

                    delay(0.4) { requestReview() }
                } onNeedOneMoreDay: {
                    smokesManager.addDay()
                } onDismiss: {
                    navigationVM.shouldShowReadyToBreakActionMenu = false
                }
            }
            .onChange(of: smokesManager.todaySmokes) { newValue in
                if newValue == smokesManager.todayLimit {
                    navigationVM.shouldShowReadyToBreakActionMenu = true
                }
            }
            .onAppear {
                if smokesManager.isDayAfterPlanEnded {
                    navigationVM.shouldShowReadyToBreakActionMenu = true
                }
            }
        }
    }
}
