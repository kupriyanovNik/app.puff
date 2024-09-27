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

    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()

            content()
                .safeAreaInset(edge: .bottom) {
                    TabBar(selectedTab: $navigationVM.selectedTab)
                }
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
        case .statistics: StatisticsView()
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
