//
//  PremiumCongratulationView.swift
//  Puff
//
//  Created by Никита Куприянов on 22.09.2024.
//

import SwiftUI

struct PremiumCongratulationView: View {

    var action: () -> Void

    @State private var shouldShowLottie: Bool = true

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            LottieView(name: "puffPremiumStarAnimation")
                .frame(120)
                .opacity(shouldShowLottie ? 1 : 0)
                .animation(.smooth, value: shouldShowLottie)

            VStack(spacing: 16) {
                Text("Добро пожаловать")
                    .font(.bold32)
                    .foregroundStyle(.white)

                Text("Puff Premium")
                    .font(.semibold26)
                    .foregroundStyle(Palette.accentColor)
                    .padding(.vertical, 3)
                    .padding(.horizontal, 20)
                    .background {
                        Capsule()
                            .fill(.white)
                    }
            }
            .padding(.horizontal, 40)

            Spacer()
        }
        .onAppear {
            delay(3.3) {
                shouldShowLottie = false
            }
        }
        .onAppear {
            delay(3.5, action: action)
        }
    }
}

#Preview {
    PremiumCongratulationView { }
}
