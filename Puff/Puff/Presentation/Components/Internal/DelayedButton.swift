//
//  DelayedButton.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import SwiftUI

struct DelayedButton<Content: View>: View {

    var afterPressedScale: Double = 0.93
    var afterPressedScaleAnchor: UnitPoint = .center
    var afterPressedOpacity: Double = 1
    var delayTime: Double = 0.1

    var isDisabled: Bool = false

    let action: () -> Void
    var actionWithoutDelay: () -> Void = {}
    let content: () -> Content

    @State private var viewScale: Double = 1
    @State private var viewOpacity: Double = 1

    @State private var isButtonPressed: Bool = false

    var body: some View {
        content()
            .contentShape(.rect)
            .opacity(isDisabled ? 0.5 : viewOpacity)
            .scaleEffect(viewScale, anchor: afterPressedScaleAnchor)
            .animation(.smooth, value: viewScale)
            .animation(.smooth, value: viewOpacity)
            .animation(.smooth, value: isDisabled)
            .onTapGesture {
                if !isDisabled {
                    performAction()
                }
            }
    }

    private func performAction() {
        if !isButtonPressed {
            viewScale = afterPressedScale
            viewOpacity = afterPressedOpacity
            isButtonPressed = true
            actionWithoutDelay()

            action()


            delay(delayTime) {
                viewScale = 1
                viewOpacity = 1
                isButtonPressed = false
            }
        }
    }
}
