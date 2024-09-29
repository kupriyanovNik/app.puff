//
//  KeyboardAwareModifier.swift
//  Puff
//
//  Created by Никита Куприянов on 29.09.2024.
//

import SwiftUI
import Combine

struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0

    var animation: Animation = .easeInOut(duration: 0.25)

    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue.height },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
       ).eraseToAnyPublisher()
    }

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(keyboardHeightPublisher) { height in
                withAnimation(animation) {
                    self.keyboardHeight = height
                }
            }
    }
}

extension View {
    func keyboardAwarePadding(animation: Animation = .easeInOut(duration: 0.25)) -> some View {
        modifier(KeyboardAwareModifier(animation: animation))
    }
}
