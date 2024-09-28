//
//  Internal.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import SwiftUI

func hideKeyboard() {
    UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil,
        from: nil,
        for: nil
    )
}

func delay(
    _ time: Double,
    action: @escaping () -> Void
) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: action)
}

func animated(
    _ animation: Animation = .smooth,
    action: @escaping () -> Void
) {
    withAnimation(animation, action)
}
