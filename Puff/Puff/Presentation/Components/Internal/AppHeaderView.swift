//
//  AppHeaderView.swift
//  Puff
//
//  Created by Никита Куприянов on 28.09.2024.
//

import SwiftUI

struct AppHeaderView: View {

    var title: String

    @ObservedObject var navigationVM: NavigationViewModel

    var body: some View {
        HStack {
            Text(title)
                .font(.semibold22)
                .foregroundStyle(Palette.textPrimary)

            Spacer()

            Button {
                navigationVM.shouldShowAccountView.toggle()
            } label: {
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
            .buttonStyle(.plain)

        }
        .padding(.bottom, 2)
        .padding(.top, 16)
        .padding(.leading, 10)
    }
}
