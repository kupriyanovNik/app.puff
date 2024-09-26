//
//  WidthCalculatorModifier.swift
//  Puff
//
//  Created by Никита Куприянов on 26.09.2024.
//

import SwiftUI

struct WidthCalculatorModifier: ViewModifier {

    @Binding var width: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            width = proxy.size.width
                        }
                }
            )
    }
}

struct HeightCalculatorModifier: ViewModifier {

    @Binding var height: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            height = proxy.size.height
                        }
                }
            )
    }
}

extension View {
    /// Функция, возвращающая ширину вью, к которому применена
    func getWidth(width: Binding<CGFloat>) -> some View {
        modifier(WidthCalculatorModifier(width: width))
    }

    /// Функция, возвращающая ширину вью, к которому применена
    func getHeight(height: Binding<CGFloat>) -> some View {
        modifier(HeightCalculatorModifier(height: height))
    }
}
