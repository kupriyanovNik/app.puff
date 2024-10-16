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
            ) {

            }

            cell(
                "AccountWidgets.Base.ControlCenter".l,
                imageName: "AccountWidgetsBaseInfoControlCenterImage"
            ) {

            }
        }
        .padding(.horizontal, 12)
    }

    @ViewBuilder
    private func cell(
        _ text: String,
        number: Int? = nil,
        imageName: String,
        action: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .cornerRadius(16)
                .overlay(alignment: .leading) {
                    Text(text)
                        .font(.semibold16)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Palette.textPrimary)
                        .padding(.leading, 16)
                }
        }
        .onTapGesture(perform: action)
    }
}

#Preview {
    AccountViewWidgetsInfoView { }
}
