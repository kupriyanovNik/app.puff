//
//  CircledTopCornersView.swift
//  Puff
//
//  Created by Никита Куприянов on 28.09.2024.
//

import SwiftUI

struct CircledTopCornersView<Content: View>: View {

    var content: () -> Content

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            Color.white
                .clipShape(
                    .rect(
                        topLeadingRadius: 28,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 28
                    )
                )
                .ignoresSafeArea(edges: .bottom)
                .overlay(content: content)
        }
        .onAppear {
            UIApplication.shared.setStatusBarStyle(.darkContent)
        }
    }
}
