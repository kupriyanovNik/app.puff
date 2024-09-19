//
//  Color+Ext.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import SwiftUI

extension Color {
    /// Инициализатор, принимающий цвет как шестнадцатеричное число 0x'NUMBER'
    init(
        hex: Int,
        alpha: Double = 1
    ) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
