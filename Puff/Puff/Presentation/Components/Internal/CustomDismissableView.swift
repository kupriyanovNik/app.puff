//
//  CustomDismissableView.swift
//  Puff
//
//  Created by Никита Куприянов on 16.10.2024.
//

import SwiftUI

struct CustomDismissableView<Content: View>: View {

    let dismissAction: () -> Void
    let content: () -> Content

    @State private var offset: Double = .zero

    private var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                self.offset = max(0, value.translation.height / 30)
            }
            .onEnded { value in
                if value.translation.height > 15 {
                    dismissAction()

                    delay(0.3) {
                        offset = .zero
                    }
                } else {
                    offset = .zero
                }
            }
    }

    var body: some View {
        CircledTopCornersView(background: .clear, content: content)
            .offset(y: min(15, offset))
            .animation(.easeOut(duration: 0.25), value: offset)
            .contentShape(.rect)
            .simultaneousGesture(gesture)
    }
}
