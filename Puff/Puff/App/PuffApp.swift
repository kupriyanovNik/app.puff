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

    @State var a: Bool = false

    var body: some Scene {
        WindowGroup {
            MainNavigationView(navigationVM: navigationVM)
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
                .sheet(isPresented: $a) {
                    ActionMenuPlanDevelopingView()
                }
                .onAppear {
                    a.toggle()
                }
        }
    }
}
