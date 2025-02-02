//
//  CircledTopCornersView.swift
//  Puff
//
//  Created by Никита Куприянов on 28.09.2024.
//

import SwiftUI

struct CircledTopCornersView<Content: View>: View {

    var radius: Double = 28
    var background: Color = .black
    var color: Color = .init(hex: 0xF5F5F5)

    var content: () -> Content

    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()

            color
                .clipShape(
                    .rect(
                        topLeadingRadius: radius,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: radius
                    )
                )
                .padding(.top, isSmallDevice ? 5 : 0)
                .ignoresSafeArea(edges: .bottom)
                .overlay(content: content)
        }
        .onAppear {
            UIApplication.shared.setStatusBarStyle(.darkContent)
        }
    }
}
