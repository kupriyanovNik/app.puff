//
//  AccountViewWidgetsInfoView.swift
//  Puff
//
//  Created by Никита Куприянов on 16.10.2024.
//

import SwiftUI

struct AccountViewWidgetsInfoView: View {

    @ObservedObject var navigationVM: NavigationViewModel

    var body: some View {
        CircledTopCornersView(background: .init(hex: 0xF5F5F5), content: viewContent)
    }

    @ViewBuilder
    private func viewContent() -> some View {
        VStack(spacing: 28) {
            headerView()

            cells()
        }
    }

    @ViewBuilder
    private func headerView() -> some View {
        HStack(spacing: 8) {
            Button(action: navigationVM.back) {
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
        .padding(.top, 10)
        .padding(.leading, 16)
    }

    @ViewBuilder
    private func cells() -> some View {
        ScrollView {
            VStack(spacing: 10) {
                cell(
                    "AccountWidgets.Base.Home".l,
                    imageName: "AccountWidgetsBaseInfoHomeScreenImage",
                    action: navigationVM.showAccountWidgetsHomeInfo
                )

                cell(
                    "AccountWidgets.Base.ControlCenter".l,
                    availableText: "AccountWidgets.Base.AvailableOnIOS18".l,
                    imageName: "AccountWidgetsBaseInfoControlCenterImage",
                    action: navigationVM.showAccountWidgetsControlCenter
                )

                cell(
                    "AccountWidgets.Base.ActionButton".l,
                    availableText: "AccountWidgets.Base.Available15ProAndNewer".l,
                    imageName: "AccountWidgetsBaseInfoActionButtonImage",
                    action: navigationVM.showAccountWidgetsActionButton
                )

                cell(
                    "AccountWidgets.Base.DoubleBackTap".l,
                    imageName: "AccountWidgetsBaseInfoDoubleBackTapImage",
                    action: navigationVM.showAccountWidgetsDoubleTap
                )

                cell(
                    "AccountWidgets.Base.LockScreen".l,
                    availableText: "AccountWidgets.Base.AvailableOnIOS18".l,
                    imageName: "AccountWidgetsBaseInfoLockScreenImage",
                    action: navigationVM.showAccountWidgetsLockScreen
                )
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

extension AccountViewWidgetsInfoView {
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
            ),
            backAction: navigationVM.back
        )
    }

    @ViewBuilder func controlCenterInfoView() -> some View {
        AccountWidgetsInfoView(
            title: "AccountWidgets.Base.ControlCenter",
            models: Array(
                (1...3).map { index in
                        .init(
                            number: index,
                            title: "AccountWidgets.ControlCenterInfo.Text\(index)",
                            imageName: "AccountWidgetsControlCenterInfo\(index)Image"
                        )
                }
            ),
            backAction: navigationVM.back
        )
    }

    @ViewBuilder func actionButtonInfoView() -> some View {
        AccountWidgetsInfoView(
            title: "AccountWidgets.Base.ActionButton",
            models: Array(
                (1...4).map { index in
                        .init(
                            number: index,
                            title: "AccountWidgets.ActionButtonInfo.Text\(index)".l,
                            imageName: "AccountWidgetsActionButtonInfo\(index)Image".l
                        )
                }
            ),
            backAction: navigationVM.back
        )
    }

    @ViewBuilder func doubleBackTapInfoView() -> some View {
        AccountWidgetsInfoView(
            title: "AccountWidgets.Base.DoubleBackTap",
            models: [
                .init(
                    number: 1,
                    title: "AccountWidgets.DoubleBackTapInfo.Text1",
                    imageName: "AccountWidgetsDoubleBackTapInfo1Image".l,
                    actionTitle: "Install".l
                ) { "AccountWidgets.DoubleBackTapInfo.Link".l.openURL() },
                .init(number: 2, title: "AccountWidgets.DoubleBackTapInfo.Text2", imageName: "AccountWidgetsDoubleBackTapInfo2Image"),
                .init(number: 3, title: "AccountWidgets.DoubleBackTapInfo.Text3", imageName: "AccountWidgetsDoubleBackTapInfo3Image".l),
                .init(number: 4, title: "AccountWidgets.DoubleBackTapInfo.Text4", imageName: "AccountWidgetsDoubleBackTapInfo4Image".l),
                .init(number: 5, title: "AccountWidgets.DoubleBackTapInfo.Text5", imageName: "AccountWidgetsDoubleBackTapInfo5Image".l)
            ],
            backAction: navigationVM.back
        )
    }

    @ViewBuilder func lockScreenInfoView() -> some View {
        AccountWidgetsInfoView(
            title: "AccountWidgets.Base.LockScreen",
            models: [
                .init(number: 1, title: "AccountWidgets.LockScreen.Text1", imageName: "AccountWidgetsLockScreenInfo1Image"),
                .init(number: 2, title: "AccountWidgets.LockScreen.Text2", imageName: "AccountWidgetsLockScreenInfo2Image"),
                .init(number: 3, title: "AccountWidgets.LockScreen.Text3", imageName: "AccountWidgetsLockScreenInfo3Image"),
                .init(number: 4, title: "AccountWidgets.LockScreen.Text4", imageName: "AccountWidgetsLockScreenInfo4Image")
            ],
            backAction: navigationVM.back
        )
    }
}
