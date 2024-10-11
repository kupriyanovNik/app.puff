//
//  AppPaywallView.swift
//  Puff
//
//  Created by Никита Куприянов on 22.09.2024.
//

import SwiftUI

struct AppPaywallView: View {

    @State private var shouldShowCongratulationView: Bool = false

    @ObservedObject var subscriptionsManager: SubscriptionsManager

    var showBenefitsDelay: Double = 0.25

    var closeScreenAction: () -> Void

    @State private var shouldShowBenefits: Bool = false

    @State private var errorText: String = ""
    @State private var shouldShowError: Bool = false

    private let benefits: [String] = Array((1...3).map { "Paywall.Benefit\($0)".l })

    private var trialString: String {
        if isSmallDevice {
            "Paywall.FreeTrialDescSmall".l
        } else {
            "Paywall.FreeTrialDesc".l
        }
    }

    private var priceString: String {
        if let product = subscriptionsManager.products.first {
            return product.displayPrice + "Paywall.Month".l
        } else {
            return "Error while fetching price"
        }
    }

    private var purchaseText: String {
        if subscriptionsManager.withTrial {
            return "Paywall.StartTrial".l
        }

        return "Continue".l
    }

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            Palette.accentColor
                .opacity(shouldShowCongratulationView ? 1 : 0)
                .animation(.easeOut(duration: 0.2).delay(0.3), value: shouldShowCongratulationView)
                .ignoresSafeArea()

            paywall()
                .opacity(shouldShowCongratulationView ? 0 : 1)

            if shouldShowCongratulationView {
                PremiumCongratulationView(action: closeScreenAction)
                    .transition(.opacity.animation(.easeOut(duration: 0.2).delay(0.3)))
            }
        }
        .prepareForStackPresentationInOnboarding()
        .animation(.easeOut(duration: 0.35), value: shouldShowCongratulationView)
        .alert(isPresented: $shouldShowError) {
            Alert(title: Text(errorText))
        }
        .task {
            if subscriptionsManager.products.isEmpty {
                await subscriptionsManager.loadProducts()
            }
        }
        .onChange(of: subscriptionsManager.isPremium) { newValue in
            if newValue {
                shouldShowCongratulationView = true
            }
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
            delay(showBenefitsDelay) {
                shouldShowBenefits = true
            }
        }
    }

    @ViewBuilder
    private func headerView() -> some View {
        VStack(spacing: isSmallDevice ? 0 : 16) {
            HStack {
                Button(action: closeScreenAction) {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Palette.textTertiary)
                        .frame(16)
                }

                Spacer()

                TextButton(text: "Paywall.Restore".l) {
                    Task {
                        await subscriptionsManager.restorePurchases { error in
                            if let error {
                                errorText = error
                                shouldShowError = true
                            } else {
                                shouldShowCongratulationView.toggle()
                            }
                        }
                    }
                }
            }

            Text("Paywall.Title".l)
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
            Text("Puffless Premium")
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

                Text("Paywall.Puffs".l)
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

                Text("Paywall.Limit".l)
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
                    .frame(isSmallDevice ? 22 : 24)

                Text(benefits[index])
                    .font(isSmallDevice ? .medium15 : .medium16)
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
                    text: purchaseText,
                    isDisabled: subscriptionsManager.products.isEmpty
                ) {
                    if !subscriptionsManager.isPremium {
                        makePurchase()
                    } else {
                        shouldShowCongratulationView = true
                    }
                }

                HStack {
                    Spacer()

                    linkText(
                        "Paywall.TermsOfUse".l,
                        urlString: "https://sites.google.com/view/puffless/eng-terms-of-use",
                        edge: .leading
                    )

                    Spacer()
                        .frame(maxWidth: 12)

                    linkText(
                        "Paywall.PrivacyPolicy".l,
                        urlString: "https://sites.google.com/view/puffless/eng-privacy-policy",
                        edge: .trailing
                    )

                    Spacer()
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
                .opacity(!isSmallDevice && subscriptionsManager.withTrial ? 1 : 0)
                .animation(.bouncy, value: subscriptionsManager.withTrial)

            HStack {
                if !isSmallDevice {
                    Spacer()
                }

                Text(priceString)
                    .font(.semibold18)
                    .foregroundStyle(Palette.textPrimary)

                Spacer()

                if isSmallDevice && subscriptionsManager.withTrial {
                    Text(trialString)
                        .font(.medium15)
                        .foregroundStyle(Palette.textSecondary)
                        .lineLimit(1)
                        .transition(.opacity.animation(.bouncy))
                }
            }
        }

        HStack {
            Text("Paywall.FreeTrial".l)
                .font(.medium16)
                .foregroundStyle(Palette.textSecondary)

            Spacer()

            Toggle("", isOn: $subscriptionsManager.withTrial)
                .labelsHidden()
        }
        .padding(16)
        .background {
            Color(hex: 0xF0F0F0)
                .cornerRadius(16)
        }
    }

    @ViewBuilder
    private func linkText(_ text: String, urlString: String, edge: Edge.Set) -> some View {
        Text(text)
            .font(.medium12)
            .lineLimit(1)
            .foregroundStyle(Palette.textTertiary)
            .underline(color: Palette.textTertiary)
            .padding(.bottom, 10)
            .padding(edge, 8)
            .padding(.top, 4)
            .onTapGesture(perform: urlString.openURL)
    }

    private func makePurchase() {
        Task {
            await subscriptionsManager.buyProduct() { error in
                if let error {
                    errorText = error
                    shouldShowError = true
                }
            }
        }
    }
}

#Preview {
    AppPaywallView(subscriptionsManager: .init()) { }
}
