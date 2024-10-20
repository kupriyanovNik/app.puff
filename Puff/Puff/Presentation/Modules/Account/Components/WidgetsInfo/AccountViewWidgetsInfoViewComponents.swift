//
//  AccountViewWidgetsInfoViewComponents.swift
//  Puff
//
//  Created by Никита Куприянов on 26.10.2024.
//

import SwiftUI

extension AccountViewWidgetsInfoView {
    struct AccountViewWidgetsHomeScreenInfoView: View {

        var backAction: () -> Void

        private let images: [String] = Array((1...2).map { "AccountWidgetsHomeInfo\($0)Image" })
        private let texts: [String] = Array((1...2).map { "AccountWidgets.HomeInfo.Text\($0)".l })

        var body: some View {
            CustomDismissableView(dismissAction: backAction, content: viewContent)
        }

        @ViewBuilder
        private func viewContent() -> some View {
            VStack(spacing: 28) {
                headerView()

                cells()

                Spacer()
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

                Text("AccountWidgets.HomeInfoTitle".l)
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
                cell(index: 0)
                cell(index: 1)
            }
            .padding(.horizontal, 12)
        }


        @ViewBuilder
        private func cell(index: Int) -> some View {
            Image(images[index])
                .resizable()
                .scaledToFit()
                .cornerRadius(16)
                .overlay(alignment: .topLeading) {
                    Text("\(index + 1)")
                        .font(.semibold22)
                        .foregroundStyle(Palette.textPrimary)
                        .padding([.leading, .top], 16)
                }
                .overlay(alignment: .bottomLeading) {
                    Text(texts[index])
                        .font(.medium15)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Palette.textSecondary)
                        .padding([.leading, .bottom], 16)
                }
        }
    }

    struct AccountViewWidgetsControlCenterInfoView: View {

        var backAction: () -> Void

        private let images: [String] = Array((1...3).map { "AccountWidgetsControlCenterInfo\($0)Image" })
        private let texts: [String] = Array((1...3).map { "AccountWidgets.ControlCenterInfo.Text\($0)".l })

        var body: some View {
            CustomDismissableView(dismissAction: backAction, content: viewContent)
        }

        @ViewBuilder
        private func viewContent() -> some View {
            VStack(spacing: 28) {
                headerView()

                cells()

                Spacer()
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

                Text("AccountWidgets.ControlCenterInfoTitle".l)
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
                cell(index: 0)
                cell(index: 1)
                cell(index: 2)
            }
            .padding(.horizontal, 12)
        }


        @ViewBuilder
        private func cell(index: Int) -> some View {
            Image(images[index])
                .resizable()
                .scaledToFit()
                .cornerRadius(16)
                .overlay(alignment: .topLeading) {
                    Text("\(index + 1)")
                        .font(.semibold22)
                        .foregroundStyle(Palette.textPrimary)
                        .padding([.leading, .top], 16)
                }
                .overlay(alignment: .bottomLeading) {
                    Text(texts[index])
                        .font(.medium15)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Palette.textSecondary)
                        .padding([.leading, .bottom], 16)
                }
        }
    }
}
