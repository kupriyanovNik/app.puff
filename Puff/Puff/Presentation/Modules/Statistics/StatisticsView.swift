//
//  StatisticsView.swift
//  Puff
//
//  Created by Никита Куприянов on 19.09.2024.
//

import SwiftUI

struct StatisticsView: View {

    @ObservedObject var navigationVM: NavigationViewModel

    var body: some View {
        CircledTopCornersView(content: viewContent)
    }

    @ViewBuilder
    private func viewContent() -> some View {
        VStack(spacing: 10) {
            AppHeaderView(title: "Прогресс", navigationVM: navigationVM)

            Spacer()

            Text("Hello, World!")

            Spacer()
        }
        .padding(.horizontal, 12)
    }
}

#Preview {
    StatisticsView(navigationVM: .init())
}
