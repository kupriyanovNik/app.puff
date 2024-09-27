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
                    smokesManager: smokesManager
                )
            }
            .preferredColorScheme(.light)
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
            .makeCustomSheet(isPresented: $navigationVM.shouldShowPlanDevelopingActionMenu) {
                ActionMenuPlanDevelopingView {
                    navigationVM.shouldShowPlanDevelopingActionMenu.toggle()
                }
            }
        }
    }
}
