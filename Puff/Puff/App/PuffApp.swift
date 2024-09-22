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

    var body: some Scene {
        WindowGroup {
//            MainNavigationView(navigationVM: navigationVM)
            OnboardingView(onboardingVM: onboardingVM)
                .preferredColorScheme(.light)
        }
    }
}
