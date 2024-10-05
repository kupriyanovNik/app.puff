//
//  TabBar.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import SwiftUI

struct TabBar: View {

    @Binding var selectedTab: TabBarModel

    var body: some View {
        HStack {
            ForEach(TabBarModel.allCases, id: \.self) {
                tab($0)
            }
        }
        .overlay {
            Capsule()
                .fill(Palette.textTertiary)
                .frame(width: 1, height: 22)
        }
        .background(Color(hex: 0xF5F5F5))
    }

    @ViewBuilder
    private func tab(_ tab: TabBarModel) -> some View {
        let isSelected = tab == selectedTab

        VStack(spacing: 4) {
            Image(isSelected ? tab.selectedImageName : tab.defaultImageName)
                .resizable()
                .scaledToFit()
                .frame(22)

            Text(tab.title)
                .font(.semibold14)
                .foregroundStyle(isSelected ? Palette.textPrimary : Palette.textTertiary)
        }
        .hCenter()
        .padding(.bottom, 5)
        .padding(.top, 15)
        .contentShape(.rect)
        .animation(.smooth, value: isSelected)
        .onTapGesture {
            selectedTab = tab
        }
    }
}
