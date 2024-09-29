//
//  PuffApp.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import SwiftUI

@main
struct PuffApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject var navigationVM = NavigationViewModel()
    @StateObject var onboardingVM = OnboardingViewModel()
    @StateObject var smokesManager = SmokesManager()

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
                ActionMenuReadyToBreakView(tappedReadyToBreak: false, todayLimit: 0) {
                    smokesManager.endPlan()
                } onNeedOneMoreDay: {
                    smokesManager.addDay()
                } onDismiss: {
                    navigationVM.shouldShowReadyToBreakActionMenu = false
                }
            }
        }
    }
}
