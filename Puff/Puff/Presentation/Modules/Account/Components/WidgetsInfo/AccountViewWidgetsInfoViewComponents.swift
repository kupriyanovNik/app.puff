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
    var withScroll: Bool = false
    let models: [AccountWidgetsInfoModel]

    var backAction: () -> Void

    var body: some View {
        CustomDismissableView(
            ableToDismissBySlidingDown: !withScroll,
            dismissAction: backAction,
            content: viewContent
        )
    }

    @ViewBuilder
    private func viewContent() -> some View {
        Group {
            if withScroll {
                ScrollView {
                    baseView()
                }
                .scrollIndicators(.hidden)
            } else {
                baseView()
            }
        }
    }

    @ViewBuilder
    private func baseView() -> some View {
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

            Text(title.l.replacingOccurrences(of: "\n", with: " "))
                .font(.semibold22)
                .foregroundStyle(Palette.textPrimary)
                .lineLimit(1)

            Spacer()
        }
        .padding(.top, 22)
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
                        .padding([.leading, .bottom], 16)

                    if let actionTitle = model.actionTitle {
                        AccentButton(text: actionTitle.l, action: model.action)
                    }
                }
            }
    }
}
