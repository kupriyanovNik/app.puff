//
//  AppPaywallView.swift
//  Puff
//
//  Created by Никита Куприянов on 22.09.2024.
//

import SwiftUI

struct AppPaywallView: View {

    @State private var withTrial: Bool = false

    var action: () -> Void

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
        VStack(spacing: isSmallDevice ? 20 : 38) {
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

            Spacer()
        }
        .safeAreaInset(edge: .bottom, content: bottomView)
        .prepareForStackPresentationInOnboarding()
    }

    @ViewBuilder
    private func headerView() -> some View {
        VStack(spacing: 4) {
            HStack {
                DelayedButton(afterPressedScale: 1.2, action: action) {
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
            .padding(.leading, 20)
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
            .padding(.trailing, 20)
        }
    }

    @ViewBuilder
    private func benefitView(index: Int) -> some View {
        let imageName = "subscriptionBenefits\(index + 1)Image"

        HStack(spacing: 6) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(24)

            Text(benefits[index])
                .font(.medium16)
                .foregroundStyle(Palette.textPrimary)
                .lineLimit(1)

            Spacer()
        }
    }

    @ViewBuilder
    private func bottomView() -> some View {
        VStack(spacing: 12) {
            trialView()

            VStack(spacing: 5) {
                AccentButton(text: "Продолжить", action: makePurchase)

                HStack {
                    linkText("Условия использования", urlString: "")

                    Spacer()

                    linkText("Политика конфиденциальности", urlString: "")
                }
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
                .animation(.smooth, value: withTrial)

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
                        .transition(.opacity.combined(with: .move(edge: .trailing)).animation(.smooth))
                        .animation(.smooth)
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
            .font(isSmallDevice ? .medium13 : .medium15)
            .lineLimit(1)
            .foregroundStyle(Palette.textTertiary)
            .underline(color: Palette.textTertiary)
            .padding(.bottom, 10)
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

    }
}

#Preview {
    AppPaywallView { }
}
