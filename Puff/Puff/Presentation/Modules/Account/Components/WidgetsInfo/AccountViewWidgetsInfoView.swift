//
//  AccountViewWidgetsInfoView.swift
//  Puff
//
//  Created by Никита Куприянов on 16.10.2024.
//

import SwiftUI

struct AccountViewWidgetsInfoView: View {

    var backAction: () -> Void

    @State private var shouldShowHomeScreenInfo: Bool = false
    @State private var shouldShowControlCenterInfo: Bool = false
    @State private var shouldShowActionButtonInfo: Bool = false
    @State private var shouldShowDoubleBackTapInfo: Bool = false
    @State private var shouldShowLockScreenInfo: Bool = false

    var body: some View {
        CustomDismissableView(
            ableToDismissBySlidingDown: false,
            dismissAction: backAction,
            content: viewContent
        )
    }

    @ViewBuilder
    private func viewContent() -> some View {
        VStack(spacing: 28) {
            headerView()

            cells()
        }
        .makeCustomConditionalView(shouldShowHomeScreenInfo, content: homeScreenInfoView)
        .makeCustomConditionalView(shouldShowControlCenterInfo, content: controlCenterInfoView)
        .makeCustomConditionalView(shouldShowActionButtonInfo, content: actionButtonInfoView)
        .makeCustomConditionalView(shouldShowDoubleBackTapInfo, content: doubleBackTapInfoView)
        .makeCustomConditionalView(shouldShowLockScreenInfo, content: lockScreenInfoView)
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
        ScrollView {
            VStack(spacing: 10) {
                cell(
                    "AccountWidgets.Base.Home".l,
                    imageName: "AccountWidgetsBaseInfoHomeScreenImage"
                ) {
                    shouldShowHomeScreenInfo = true
                }

                cell(
                    "AccountWidgets.Base.ControlCenter".l,
                    availableText: "AccountWidgets.Base.AvailableOnIOS18".l,
                    imageName: "AccountWidgetsBaseInfoControlCenterImage"
                ) {
                    shouldShowControlCenterInfo = true
                }

                cell(
                    "AccountWidgets.Base.ActionButton".l,
                    availableText: "AccountWidgets.Base.Available15ProAndNewer".l,
                    imageName: "AccountWidgetsBaseInfoActionButtonImage"
                ) {
                    shouldShowActionButtonInfo = true
                }

                cell(
                    "AccountWidgets.Base.DoubleBackTap".l,
                    imageName: "AccountWidgetsBaseInfoDoubleBackTapImage"
                ) {
                    shouldShowDoubleBackTapInfo = true
                }

                cell(
                    "AccountWidgets.Base.LockScreen".l,
                    availableText: "AccountWidgets.Base.AvailableOnIOS18".l,
                    imageName: "AccountWidgetsBaseInfoLockScreenImage"
                ) {
                    shouldShowLockScreenInfo = true
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, isSmallDevice ? 22 : 0)
        }
        .scrollIndicators(.hidden)
    }

    @ViewBuilder
    private func cell(
        _ text: String,
        availableText: String? = nil,
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
                if let availableText {
                    Group {
                        Text(availableText)
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


private extension AccountViewWidgetsInfoView {
    @ViewBuilder func homeScreenInfoView() -> some View {
        AccountWidgetsInfoView(
            title: "AccountWidgets.Base.Home",
            models: Array(
                (1...2).map { index in
                    AccountWidgetsInfoModel(
                        number: index,
                        title: "AccountWidgets.HomeInfo.Text\(index)",
                        imageName: "AccountWidgetsHomeInfo\(index)Image"
                    )
                }
            )
        ) {
            shouldShowHomeScreenInfo = false
        }
    }

    @ViewBuilder func controlCenterInfoView() -> some View {
        AccountWidgetsInfoView(
            title: "AccountWidgets.Base.ControlCenter",
            models: Array(
                (1...3).map { index in
                    AccountWidgetsInfoModel(
                        number: index,
                        title: "AccountWidgets.ControlCenterInfo.Text\(index)",
                        imageName: "AccountWidgetsControlCenterInfo\(index)Image"
                    )
                }
            )
        ) {
            shouldShowControlCenterInfo = false
        }
    }

    @ViewBuilder func actionButtonInfoView() -> some View {
        AccountWidgetsInfoView(
            title: "AccountWidgets.Base.ActionButton",
            models: Array(
                (1...4).map { index in
                    AccountWidgetsInfoModel(
                        number: index,
                        title: "AccountWidgets.ActionButtonInfo.Text\(index)".l,
                        imageName: "AccountWidgetsActionButtonInfo\(index)Image".l
                    )
                }
            )
        ) {
            shouldShowActionButtonInfo = false
        }
    }

    @ViewBuilder func doubleBackTapInfoView() -> some View {
//        AccountWidgetsInfoView(
//            title: "AccountWidgetsBaseInfoDoubleBackTapImage",
//            models: <#T##[AccountWidgetsInfoModel]#>,
//            backAction: <#T##() -> Void#>
//        )
    }

    @ViewBuilder func lockScreenInfoView() -> some View {

    }
}
