//
//  HomeSmokeButtonStyle.swift
//  Puff
//
//  Created by Никита Куприянов on 12.10.2024.
//

import SwiftUI

struct HomeSmokeButtonStyle: ButtonStyle {

    @ObservedObject var smokesManager: SmokesManager

    @State private var isButtonPressed: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(isButtonPressed ? 0.7 : 1)
            .scaleEffect(isButtonPressed ? 0.99 : 1)
            .animation(.easeInOut(duration: 0.1), value: isButtonPressed)
            .overlay {
                Group {
                    if smokesManager.isTodayLimitExceeded && smokesManager.isPlanStarted {
                        Image(.homeSmokeExceededButton)
                            .resizable()
                    } else if smokesManager.todaySmokes == smokesManager.todayLimit && smokesManager.isPlanStarted {
                        Image(.homeSmokeOnEdgeButton)
                            .resizable()
                    } else {
                        Image(.homeSmokeNonExceededButton)
                            .resizable()
                    }
                }
                .scaledToFit()
                .frame(32)
                .padding(.vertical, 10)
                .padding(.horizontal, 35)
                .background {
                    Capsule()
                        .fill(.white)
                }
            }
            .onChange(of: configuration.isPressed) { newValue in
                if newValue {
                    isButtonPressed = true
                } else {
                    delay(0.15) {
                        isButtonPressed = false
                    }
                }
            }
    }
}
