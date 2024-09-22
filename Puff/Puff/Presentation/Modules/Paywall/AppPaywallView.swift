//
//  AppPaywallView.swift
//  Puff
//
//  Created by Никита Куприянов on 22.09.2024.
//

import SwiftUI

struct AppPaywallView: View {

    @State private var shouldShowCongratulationView: Bool = false

    @State private var withTrial: Bool = false

    var closeScreenAction: () -> Void

    @State private var shouldShowBenefits: Bool = false

    private let benefits: [String] = [
        "Доступ к плану бросания",
        "Адаптивный темп и лимиты",
        "Детальная статистика"
    ]

    let isSmallDevice = UIScreen.main.bounds.height < 700

    private var trialString: String {
        if isSmallDevice {
            "Пробный период 3 дня"
        } else {
            "Пробный период 3 дня, затем"
        }
    }

    private let priceString: String = {
        "299₽/месяц"
    }()

    var body: some View {
        ZStack {
            Palette.accentColor
                .ignoresSafeArea()
                .opacity(shouldShowCongratulationView ? 1 : 0)
                .animation(.easeOut(duration: 0.3), value: shouldShowCongratulationView)

            Group {
                if shouldShowCongratulationView {
                    PremiumCongratulationView(action: closeScreenAction)
                        .transition(.opacity.animation(.easeOut(duration: 0.2).delay(0.3)))
                } else {
                    paywall()
                        .transition(.opacity.animation(.easeOut(duration: 0.35)))
                }
            }
            .prepareForStackPresentationInOnboarding()
        }
    }

    @ViewBuilder
    private func paywall() -> some View {
        VStack(spacing: isSmallDevice ? 28 : 38) {
            headerView()

            VStack(spacing: 18) {
                infoCardView()

                    VStack(spacing: 12) {
                        ForEach(0..<3) { index in
                            benefitView(index: index)
                        }
                    }
                    .padding(.horizontal, 16)

            }
            .vTop()
        }
        .safeAreaInset(edge: .bottom, content: bottomView)
        .onAppear {
            delay(0.25) {
                shouldShowBenefits = true
            }
        }
    }

    @ViewBuilder
    private func headerView() -> some View {
        VStack(spacing: isSmallDevice ? 0 : 16) {
            HStack {
                DelayedButton(afterPressedScale: 1.2, action: closeScreenAction) {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Palette.textTertiary)
                        .frame(16)
                }

                Spacer()

                TextButton(text: "Восстановить покупки", action: restorePurchases)
            }

            Text("Начните свой план\nбросания")
                .font(.bold28)
                .multilineTextAlignment(.center)
                .foregroundStyle(Palette.textPrimary)
                .lineLimit(2, reservesSpace: true)
                .padding(.horizontal, isSmallDevice ? 0 : 20)
        }
        .padding(.horizontal, 16)
        .padding(.top, isSmallDevice ? 16 : 0)
    }

    @ViewBuilder
    private func infoCardView() -> some View {
        Group {
            if isSmallDevice {
                Image("purchaseInfoSmallImage")
                    .resizable()
                    .scaledToFill()
            } else {
                Image("purchaseInfoImage")
                    .resizable()
                    .scaledToFit()
            }
        }
        .padding(.horizontal, 12)
        .cornerRadius(24)
        .overlay(alignment: .top) {
            Text("Puff Premium")
                .font(.semibold16)
                .foregroundStyle(.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 16)
                .background {
                    Capsule()
                        .fill(Palette.darkBlue)
                }
                .offset(y: -15)
        }
        .overlay(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 3) {
                Text("184")
                    .font(.bold18)
                    .foregroundStyle(Palette.textPrimary)

                Text("Затяжки")
                    .font(.semibold14)
                    .foregroundStyle(Palette.textTertiary)
            }
            .padding(.top, 16)
            .padding(.leading, 35)
        }

        .overlay(alignment: .topTrailing) {
            VStack(alignment: .trailing, spacing: 3) {
                Text("300")
                    .font(.bold18)
                    .foregroundStyle(Palette.textPrimary)

                Text("Лимит")
                    .font(.semibold14)
                    .foregroundStyle(Palette.textTertiary)
            }
            .padding(.top, 16)
            .padding(.trailing, 35)
        }
    }

    @ViewBuilder
    private func benefitView(index: Int) -> some View {
        let imageName = "subscriptionBenefits\(index + 1)Image"

        if shouldShowBenefits {
            HStack(spacing: 6) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(isSmallDevice ? 24 : 28)

                Text(benefits[index])
                    .font(isSmallDevice ? .medium16 : .medium18)
                    .foregroundStyle(Palette.textPrimary)
                    .lineLimit(1)

                Spacer()
            }
            .transition(
                .opacity
                    .combined(with: .offset(y: 10))
                    .animation(.bouncy.delay(0.05 * Double(index)))
            )
            .animation(.bouncy.delay(0.08 * Double(index)))
        }
    }

    @ViewBuilder
    private func bottomView() -> some View {
        VStack(spacing: 12) {
            trialView()

            VStack(spacing: 5) {
                AccentButton(
                    text: withTrial ? "Начать пробный период" : "Продолжить",
                    action: makePurchase
                )

                HStack {
                    linkText("Условия использования", urlString: "")

                    Spacer()

                    linkText("Политика конфиденциальности", urlString: "")
                }
                .padding(.bottom, isSmallDevice ? 16 : 0)
            }
        }
        .padding(.horizontal, 12)
    }

    @ViewBuilder
    private func trialView() -> some View {
        VStack(spacing: 4) {
            Text(trialString)
                .font(.medium15)
                .foregroundStyle(Palette.textSecondary)
                .opacity(!isSmallDevice && withTrial ? 1 : 0)
                .animation(.bouncy, value: withTrial)

            HStack {
                if !isSmallDevice {
                    Spacer()
                }

                Text(priceString)
                    .font(.semibold18)
                    .foregroundStyle(Palette.textPrimary)

                Spacer()

                if isSmallDevice && withTrial {
                    Text(trialString)
                        .font(.medium15)
                        .foregroundStyle(Palette.textSecondary)
                        .lineLimit(1)
                        .transition(.opacity.animation(.bouncy))
                }
            }
        }

        HStack {
            Text("Пробный период")
                .font(.medium16)
                .foregroundStyle(Palette.textSecondary)

            Spacer()

            Toggle("", isOn: $withTrial)
                .labelsHidden()
        }
        .padding(16)
        .background {
            Color(hex: 0xF0F0F0)
                .cornerRadius(16)
        }
    }

    @ViewBuilder
    private func linkText(_ text: String, urlString: String) -> some View {
        Text(text)
            .font(.medium12)
            .lineLimit(1)
            .foregroundStyle(Palette.textTertiary)
            .underline(color: Palette.textTertiary)
            .padding(.bottom, 10)
            .padding(.horizontal, isSmallDevice ? 8 : 14)
            .padding(.top, 4)
            .onTapGesture {
                if let url = URL(string: urlString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
            }
            .minimumScaleFactor(0.9)
    }

    private func restorePurchases() {
        
    }

    private func makePurchase() {
        shouldShowCongratulationView.toggle()
    }
}

#Preview {
    AppPaywallView { }
}
