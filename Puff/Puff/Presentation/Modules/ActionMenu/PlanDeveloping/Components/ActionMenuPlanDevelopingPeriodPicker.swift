//
//  ActionMenuPlanDevelopingPeriodPicker.swift
//  Puff
//
//  Created by Никита Куприянов on 26.09.2024.
//

import SwiftUI

struct ActionMenuPlanDevelopingPeriodPicker: View {

    @Binding var selectedOption: ActionMenuPlanDevelopingPeriod

    private let cardSize: Double = (UIScreen.main.bounds.width - 44) / 3.0

    var body: some View {
        VStack(spacing: 18) {
            Text("ActionMenuPlanDeveloping.Plan.QuitPlan".l)
                .font(.bold22)
                .foregroundStyle(Palette.textPrimary)

            HStack(spacing: 10) {
                ForEach(ActionMenuPlanDevelopingPeriod.allCases, id: \.self) { option in
                    card(option)
                }
            }
            .padding(.horizontal, 12)

            Text(selectedOption.description)
                .font(.medium16)
                .multilineTextAlignment(.center)
                .foregroundStyle(Palette.textSecondary)
                .padding(.horizontal, 24)
                .lineLimit(3, reservesSpace: true)
        }
    }

    @ViewBuilder
    private func card(_ option: ActionMenuPlanDevelopingPeriod) -> some View {
        let isSelected = option == selectedOption

        DelayedButton {
            selectedOption = option
        } content: {
            VStack(alignment: .leading) {
                Text(option.title)
                    .font(.semibold16)
                    .foregroundStyle(isSelected ? .white : Palette.textPrimary)
                    .hLeading()

                Spacer()

                Text(option.subtitle)
                    .font(.medium15)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(isSelected ? .white.opacity(0.7) : Palette.textSecondary)
                    .hLeading()
            }
            .padding(12)
            .frame(cardSize)
            .background {
                if isSelected {
                    Color(hex: 0x75B8FD)
                } else {
                    Color(hex: 0xF0F0F0)
                }
            }
            .cornerRadius(16)
            .animation(.easeOut(duration: 0.3), value: isSelected)
        }
        .hCenter()
    }
}

#Preview {
    ActionMenuPlanDevelopingPeriodPicker(selectedOption: .constant(.mid))
}
