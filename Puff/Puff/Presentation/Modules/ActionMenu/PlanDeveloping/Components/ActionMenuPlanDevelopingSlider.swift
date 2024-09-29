//
//  ActionMenuPlanDevelopingSlider.swift
//  Puff
//
//  Created by Никита Куприянов on 23.09.2024.
//

import SwiftUI

struct ActionMenuPlanDevelopingSlider: View {

    @Binding var percentage: Double

    var todaySmokes: Int

    private let circleSize: Double = 40
    private let sliderHeight: Double = 10

    var body: some View {
        baseView()
            .height(34)
    }

    @ViewBuilder
    private func baseView() -> some View {
        GeometryReader { proxy in
            let size = proxy.size

            Capsule()
                .fill(Color(hex: 0xE7E7E7))
                .frame(width: size.width, height: sliderHeight)
                .overlay(alignment: .leading) {
                    Capsule()
                        .fill(Palette.accentColor)
                        .width(size.width * Double(self.percentage / 100) + (circleSize / 2))
                }
                .padding(.vertical, (circleSize - sliderHeight) / 2)
                .overlay(alignment: .leading) {
                    Circle()
                        .fill(.white)
                        .overlay {
                            Circle()
                                .fill(Palette.accentColor)
                                .padding(3)
                        }
                        .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: 0)
                        .offset(x: size.width * Double(self.percentage / 100) - (circleSize / 2))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    self.percentage = min(
                                        100, max(0, Double(value.location.x / size.width * 100))
                                    )
                                }
                        )
                }
        }
    }
}
