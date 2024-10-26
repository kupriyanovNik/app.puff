//
//  AccountViewWidgetsInfoView.swift
//  Puff
//
//  Created by Никита Куприянов on 16.10.2024.
//

import SwiftUI

struct AccountViewWidgetsInfoView: View {

    var backAction: () -> Void

    @State private var shouldShowHomeInfo: Bool = false
    @State private var shouldShowControlCenterInfo: Bool = false
    @State private var shouldShowActionButtonInfo: Bool = false
    @State private var shouldShowDoubleBackTapInfo: Bool = false
    @State private var shouldShowLockScreenInfo: Bool = false

    var body: some View {
        CustomDismissableView(
            ableToDismissBySlidingDown: (shouldShowHomeInfo == false) && (shouldShowControlCenterInfo == false),
            dismissAction: backAction,
            content: viewContent
        )
    }

    @ViewBuilder
    private func viewContent() -> some View {
        VStack(spacing: 28) {
            headerView()

            cells()

            Spacer()
        }
        .overlay {
            Group {
                if shouldShowHomeInfo {
                    AccountViewWidgetsHomeScreenInfoView {
                        shouldShowHomeInfo = false
                    }
                    .preferredColorScheme(.light)
                    .transition(
                        .opacity.combined(with: .offset(y: 50))
                        .animation(.mainAnimation)
                    )
                }
            }
            .animation(.mainAnimation, value: shouldShowHomeInfo)
        }
        .overlay {
            Group {
                if shouldShowControlCenterInfo {
                    AccountViewWidgetsControlCenterInfoView {
                        shouldShowControlCenterInfo = false
                    }
                    .preferredColorScheme(.light)
                    .transition(
                        .opacity.combined(with: .offset(y: 50))
                        .animation(.mainAnimation)
                    )
                }
            }
            .animation(.mainAnimation, value: shouldShowControlCenterInfo)
        }
    }

    @ViewBuilder
    private func headerView() -> some View {
        HStack(spacing: 8) {
            Button(action: backAction) {
                Image(.accountBack)
                    .resizable()
                    .scaledToFit()
                    .frame(26)
            }

            Text("Account.Widgets".l)
                .font(.semibold22)
                .foregroundStyle(Palette.textPrimary)

            Spacer()
        }
        .padding(.top, 22)
        .padding(.leading, 16)
    }

    @ViewBuilder
    private func cells() -> some View {
        VStack(spacing: 10) {
            cell(
                "AccountWidgets.Base.Home".l,
                imageName: "AccountWidgetsBaseInfoHomeImage"
            ) { shouldShowHomeInfo = true }

            cell(
                "AccountWidgets.Base.ControlCenter".l,
                target: 18,
                imageName: "AccountWidgetsBaseInfoControlCenterImage"
            ) { shouldShowControlCenterInfo = true }
        }
        .padding(.horizontal, 12)
    }

    @ViewBuilder
    private func cell(
        _ text: String,
        target: Int? = nil,
        imageName: String,
        action: @escaping () -> Void
    ) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .cornerRadius(16)
            .overlay(alignment: .bottomLeading) {
                Text(text)
                    .font(.semibold18)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Palette.textPrimary)
                    .padding([.leading, .bottom], 16)
            }
            .overlay(alignment: .topLeading) {
                if let target {
                    Group {
                        Text(
                            "AccountWidgets.Base.AvailableFromTarget".l.formatByDivider(
                                divider: "{number}",
                                count: target
                            )
                        )
                        .font(.semibold12)
                        .foregroundStyle(Palette.textPrimary)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .background {
                            Capsule()
                                .fill(.white)
                        }
                    }
                    .padding([.leading, .top], 16)
                }
            }
            .onTapGesture(perform: action)
    }
}

#Preview {
    AccountViewWidgetsInfoView { }
}
