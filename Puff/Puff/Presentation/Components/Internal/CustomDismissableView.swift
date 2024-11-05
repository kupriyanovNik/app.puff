//
//  CustomDismissableView.swift
//  Puff
//
//  Created by Никита Куприянов on 16.10.2024.
//

import SwiftUI

/// unused now
struct CustomDismissableView<Content: View>: View {

    var ableToDismissBySlidingDown: Bool = true

    let dismissAction: () -> Void
    let content: () -> Content

    @State private var offset: Double = .zero

    private var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if ableToDismissBySlidingDown {
                    self.offset = max(0, value.translation.height / 30)
                }
            }
            .onEnded { value in
                if ableToDismissBySlidingDown {
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
    }

    var body: some View {
        CircledTopCornersView(background: .clear, content: content)
            .offset(y: min(15, offset))
            .animation(.easeOut(duration: 0.25), value: offset)
            .contentShape(.rect)
            .simultaneousGesture(gesture)
    }
}
