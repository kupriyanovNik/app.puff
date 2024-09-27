//
//  HomeView.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import SwiftUI
import UIKit

struct HomeView: View {

    @ObservedObject var navigationVM: NavigationViewModel
    @ObservedObject var smokesManager: SmokesManager

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
    }

    @ViewBuilder
    private func viewContent() -> some View {
        VStack(spacing: 10) {
            headerView()

            planView()

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
        .padding(.leading, 22)
        .padding(.trailing, 12)
    }

    @ViewBuilder
    private func planView() -> some View {
        Group {
            if !SubscriptionManager.shared.isPremium {
                DelayedButton {
                    navigationVM.shouldShowPaywall.toggle()
                } content: {
                    HStack(spacing: 3) {
                        Image(.homeStartPlanCalendar)
                            .resizable()
                            .scaledToFit()
                            .frame(22)
                            .opacity(0.56)

                        Text("Начать план бросания")
                            .font(.semibold16)
                            .foregroundStyle(.white.opacity(0.56))
                            .padding(.vertical, 14)

                        Spacer()

                        Text("Premium")
                            .font(.semibold16)
                            .foregroundStyle(Palette.textPrimary)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 10)
                            .background {
                                Capsule()
                                    .fill(.white)
                            }
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 10)
                    .background {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Palette.darkBlue)
                    }
                }
            } else if !smokesManager.isPlanCreated {
                DelayedButton {
                    navigationVM.shouldShowPlanDevelopingActionMenu.toggle()
                } content: {
                    HStack(spacing: 3) {
                        Spacer()

                        Image(.homeStartPlanCalendar)
                            .resizable()
                            .scaledToFit()
                            .frame(22)

                        Text("Начать план бросания")
                            .font(.semibold16)
                            .foregroundStyle(.white)

                        Spacer()
                    }
                    .padding(.vertical, 14)
                    .background {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Palette.darkBlue)
                    }
                }
            } else {
                
            }
        }
    }
}

#Preview {
    HomeView(
        navigationVM: .init(),
        smokesManager: .init()
    )
}
