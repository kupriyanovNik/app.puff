//
//  ActionMenuWrongIndexView.swift
//  Puff
//
//  Created by Никита Куприянов on 10.11.2024.
//

import SwiftUI

struct ActionMenuWrongIndexView: View {
    var body: some View {
        VStack(spacing: 18) {
            LottieView(name: "ActionMenuYesterdayPlanExceededCriticalAnimation", delay: 0.3)
                .frame(68)
                .padding(.bottom, -14)

            MarkdownText(
                text: "ActionMenuWrongIndex.Title".l,
                markdowns: ["дату и время", "date and time"],
                accentColor: .init(hex: 0xFF7D7D)
            )
            .font(.bold22)
            .multilineTextAlignment(.center)

            Text("ActionMenuWrongIndex.Description".l)
                .font(.medium16)
                .multilineTextAlignment(.center)
                .foregroundStyle(Palette.textSecondary)
                .padding(.bottom, 14)

//            AccentButton(text: "ActionMenuWrongIndex.Button".l) {
//                UIApplication.openSettingsURLString.openURL()
//            }
//            .padding(.horizontal, -12)
        }
        .hCenter()
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
}

#Preview {
    ActionMenuWrongIndexView()
}
