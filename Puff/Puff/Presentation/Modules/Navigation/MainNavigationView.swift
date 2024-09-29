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

    @State var a = false

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
        onboardingVM: .init()
    )
}
