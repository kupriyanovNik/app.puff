//
//  HomeView.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import SwiftUI
import UIKit
import Combine

struct HomeView: View {

    @ObservedObject var navigationVM: NavigationViewModel
    @ObservedObject var smokesManager: SmokesManager
    @ObservedObject var onboardingVM: OnboardingViewModel

    @State private var isUserPremium = SubscriptionManager.shared.isPremium

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            Color.white
                .clipShape(
                    .rect(
                        topLeadingRadius: 28,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 28
                    )
                )
                .ignoresSafeArea(edges: .bottom)
                .overlay(content: viewContent)
        }
        .onAppear {
            UIApplication.shared.setStatusBarStyle(.darkContent)
        }
        .onChange(of: onboardingVM.hasSeenOnboarding) { _ in
            checkUserStatus()
        }
        .onChange(of: navigationVM.shouldShowPaywall) { _ in
            checkUserStatus()
        }
    }

    @ViewBuilder
    private func viewContent() -> some View {
        VStack(spacing: 10) {
            headerView()

            planView()

            HomeViewTodaySmokesView(smokesManager: smokesManager, isUserPremium: $isUserPremium)

            HomeViewSmokeButton(smokesManager: smokesManager)

            Spacer()
        }
        .padding(.horizontal, 12)
    }

    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            Text("Главная")
                .font(.semibold22)
                .foregroundStyle(Palette.textPrimary)

            Spacer()

            DelayedButton {
                navigationVM.shouldShowAccountView.toggle()
            } content: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: 0xE7E7E7))
                    .frame(34)
                    .overlay {
                        Image(.homeAccount)
                            .resizable()
                            .scaledToFit()
                            .frame(24)
                    }
            }

        }
        .padding(.bottom, 2)
        .padding(.top, 16)
        .padding(.leading, 10)
    }

    @ViewBuilder
    private func planView() -> some View {
        Group {
            if !isUserPremium {
                HomeViewIsNotPremiumPlanView {
                    navigationVM.shouldShowPaywall.toggle()
                }
            } else if !smokesManager.isPlanCreated {
                HomeViewIsPremiumPlanNotCreatedView {
                    navigationVM.shouldShowPlanDevelopingActionMenu.toggle()
                }
            } else {
                HomeViewIsPremiumPlanCreatedView(smokesManager: smokesManager) {
                    navigationVM.shouldShowReadyToBreakActionMenu.toggle()
                }
            }
        }
    }

    private func checkUserStatus() {
        animated {
            isUserPremium = SubscriptionManager.shared.isPremium
        }
    }
}

#Preview {
    HomeView(
        navigationVM: .init(),
        smokesManager: .init(),
        onboardingVM: .init()
    )
}
