//
//  ActionMenuWidgetsTipView.swift
//  Puff
//
//  Created by Никита Куприянов on 20.10.2024.
//

import SwiftUI

struct ActionMenuWidgetsTipView: View {

    var callback: () -> Void
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            MarkdownText(
                text: "ActionMenuWidgetsTip.Title".l,
                markdowns: ["without opening the app.", "не заходя в приложение"]
            )
            .font(.bold22)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
            .padding(.bottom, -14)

            Image("ActionMenuImages.WidgetsTipImage".l)
                .resizable()
                .scaledToFit()
                .cornerRadius(16)

            AccentButton(text: "Add".l, action: callback)
                .padding(.bottom, -26)

            TextButton(text: "NotificationRequest.MaybeLater".l, action: onDismiss)
        }
        .padding(.horizontal, 12)
        .padding(.top, 20)
    }
}
