//
//  PickerCard.swift
//  Puff
//
//  Created by Никита Куприянов on 20.09.2024.
//

import SwiftUI

struct PickerCard: View {

    var title: String
    var imageName: String
    var isSelected: Bool

    var width: CGFloat = (UIScreen.main.bounds.width - 34) / 2
    var height: CGFloat = 110

    var action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Spacer()

            Text(title)
                .font(.medium15)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .foregroundStyle(!isSelected ? Color(hex: 0x030303).opacity(0.56) : .white)
        }
        .hLeading()
        .padding(14)
        .frame(width: width, height: height)
        .overlay(alignment: .topLeading) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(22)
                .padding(5)
                .background {
                    Circle()
                        .fill(
                            !isSelected ?
                            Color(hex: 0x03030314).opacity(0.08) :
                                Color.white.opacity(0.24)
                        )
                }
                .padding(14)
        }
        .background {
            if isSelected {
                Palette.accentColor
                    .cornerRadius(16)
            } else {
                Color(hex: 0xF0F0F0)
                    .cornerRadius(16)
            }
        }
        .onTapGesture(perform: action)
    }
}

#Preview {
    PickerCard(
        title: "Отношения с близкими",
        imageName: "appIconImage",
        isSelected: false
    ) {

    }
}
