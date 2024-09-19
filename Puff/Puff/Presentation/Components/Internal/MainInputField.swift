//
//  MainInputField.swift
//  Puff
//
//  Created by Никита Куприянов on 19.09.2024.
//

import SwiftUI

struct MainInputField: View {

    @Binding var text: String

    @FocusState var isFocused: Bool


    var placeholder: String = "Обратная связь"
    var placeholderFont: Font = .callout
    var fieldFont: UIFont = .systemFont(ofSize: 16, weight: .medium)
    var height: CGFloat = 140
    var background: Color = .white
    var padding: EdgeInsets = .init(
        top: 14,
        leading: 16,
        bottom: 14,
        trailing: 16
    )

    var body: some View {
        TextEditor(text: $text)
            .height(height)
            .overlay(alignment: .topLeading) {
                if text.removeExtraSpaces().isEmpty {
                    Text(placeholder)
                        .font(placeholderFont)
                        .foregroundStyle(Color(hex: 0x0303034D).opacity(0.3))
                        .offset(x: 6, y: 8)
                }
            }
            .padding(padding)
            .background(background)
            .roundedCornerWithBorder(
                borderColor: .init(hex: 0x0303031A).opacity(0.1),
                corners: [.allCorners]
            )
            .onAppear {
                UITextView.appearance().backgroundColor = UIColor(background)
                UITextView.appearance().font = fieldFont
            }
    }
}

#Preview {
    @Previewable @State var text: String = ""

    MainInputField(text: $text)
        .padding(50)
}
