//
//  MarkdownText.swift
//  Puff
//
//  Created by Никита Куприянов on 19.09.2024.
//

import SwiftUI

struct MarkdownText: View {

    var text: String
    var markdown: String
    var foregroundColor: Color = Palette.textPrimary
    var accentColor: Color = .init(hex: 0x4AA1FD)

    var body: some View {
        Text(text) { str in
            if let range = str.range(of: markdown) {
                str[range].foregroundColor = accentColor
            }
        }
        .foregroundStyle(foregroundColor)
    }
}
