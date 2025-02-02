//
//  PremiumCongratulationView.swift
//  Puff
//
//  Created by Никита Куприянов on 22.09.2024.
//

import SwiftUI

struct PremiumCongratulationView: View {

    var action: () -> Void

    @State private var shouldShowLottie: Bool = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            LottieView(name: "PaywallPuffPremiumStarAnimation")
                .frame(120)
                .cornerRadius(16)
                .opacity(shouldShowLottie ? 1 : 0)
                .animation(.easeInOut(duration: 0.2), value: shouldShowLottie)

            VStack(spacing: 16) {
                Text("Paywall.Welcome".l)
                    .font(.bold32)
                    .foregroundStyle(.white)

                Text("Puffless Premium")
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
        .overlay(alignment: .bottom) {
            Text("Paywall.Purchased".l)
                .font(.semibold18)
                .foregroundStyle(.white.opacity(0.56))
                .padding(.bottom, 30)
        }
        .onAppear {
            delay(0.4) {
                shouldShowLottie = true
            }
        }
        .onAppear {
//            delay(3.3) {
//                shouldShowLottie = false
//            }
        }
        .onAppear {
            delay(3.5, action: action)
        }
    }
}

#Preview {
    PremiumCongratulationView { }
}
