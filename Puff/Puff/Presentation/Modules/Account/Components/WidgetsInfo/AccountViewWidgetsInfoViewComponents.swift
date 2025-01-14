//
//  AccountViewWidgetsInfoViewComponents.swift
//  Puff
//
//  Created by Никита Куприянов on 26.10.2024.
//

import SwiftUI

struct AccountWidgetsInfoModel: Identifiable {
    let id = UUID()

    let number: Int
    let title: String
    let imageName: String

    var actionTitle: String? = nil
    var action: () -> Void = {}
}

struct AccountWidgetsInfoView: View {
    let title: String
    let models: [AccountWidgetsInfoModel]

    var backAction: () -> Void

    var body: some View {
        CircledTopCornersView(background: .init(hex: 0xF5F5F5), content: viewContent)
    }

    @ViewBuilder
    private func viewContent() -> some View {
        VStack(spacing: 28) {
            headerView()

            ScrollView {
                cells()
            }
            .scrollIndicators(.hidden)
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

            Text(title.l.replacingOccurrences(of: "\n", with: " "))
                .font(.semibold22)
                .foregroundStyle(Palette.textPrimary)
                .lineLimit(1)

            Spacer()
        }
        .padding(.top, 10)
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func cells() -> some View {
        VStack(spacing: 10) {
            ForEach(models, content: cell)
        }
        .padding(.horizontal, 12)
    }


    @ViewBuilder
    private func cell(_ model: AccountWidgetsInfoModel) -> some View {
        Image(model.imageName)
            .resizable()
            .scaledToFit()
            .cornerRadius(16)
            .overlay(alignment: .topLeading) {
                Text("\(model.number)")
                    .font(.semibold22)
                    .foregroundStyle(Palette.textPrimary)
                    .padding([.leading, .top], 16)
            }
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(model.title.l)
                        .font(.medium15)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Palette.textSecondary)

                    if let actionTitle = model.actionTitle {
                        AccentButton(
                            text: actionTitle.l,
                            padding: .init(top: 6, leading: 16, bottom: 6, trailing: 16),
                            withInfiniteHorizontalFrame: false,
                            action: model.action
                        )
                    }
                }
                .padding([.leading, .bottom], 16)
            }
    }
}
