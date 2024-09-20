//
//  MarkdownText.swift
//  Puff
//
//  Created by Никита Куприянов on 19.09.2024.
//

import SwiftUI

struct MarkdownText: View {

    var text: String
    var markdowns: [String]
    var foregroundColor: Color
    var accentColor: Color

    init(
        text: String,
        markdown: String,
        foregroundColor: Color = Palette.textPrimary,
        accentColor: Color = .init(hex: 0x4AA1FD)
    ) {
        self.text = text
        self.markdowns = [markdown]
        self.foregroundColor = foregroundColor
        self.accentColor = accentColor
    }

    init(
        text: String,
        markdowns: [String],
        foregroundColor: Color = Palette.textPrimary,
        accentColor: Color = .init(hex: 0x4AA1FD)
    ) {
        self.text = text
        self.markdowns = markdowns
        self.foregroundColor = foregroundColor
        self.accentColor = accentColor
    }

    var body: some View {
        Text(text) { str in
            for markdown in markdowns {
                if let range = str.range(of: markdown) {
                    str[range].foregroundColor = accentColor
                }
            }
        }
        .foregroundStyle(foregroundColor)
    }
}
