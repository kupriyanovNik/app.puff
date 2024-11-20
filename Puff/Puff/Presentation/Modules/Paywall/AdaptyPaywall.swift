//
//  AdaptyPaywall.swift
//  Puff
//
//  Created by Никита Куприянов on 06.11.2024.
//

import Adapty
import AdaptyUI
import SwiftUI

struct IdentifiableErrorWrapper: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let error: Error
}

struct PaywallViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    var placementId: String

    var shouldLoadWhenInit: Bool

    @State private var paywall: AdaptyPaywall?
    @State private var viewConfig: AdaptyUI.LocalizedViewConfiguration?

    @State private var shouldShowCongratulationView: Bool = false

    @State private var alertError: IdentifiableErrorWrapper?
    @State private var alertPaywallError: IdentifiableErrorWrapper?

    @ViewBuilder
    func contentOrSheet(content: Content) -> some View {
        ZStack {
            if let paywall, let viewConfig {
                Group {
                    if shouldShowCongratulationView {
                        congratulationView()
                    } else {
                        content
                            .paywall(
                                isPresented: $isPresented,
                                paywall: paywall,
                                viewConfiguration: viewConfig,
                                didFinishPurchase: { product, info in
                                    let isUserPremium: Bool = info.profile.accessLevels["premium"]?.isActive ?? false

                                    if let date = info.transaction.transactionDate {
                                        AdaptySubscriptionManager.shared.isPremium = true
                                        shouldShowCongratulationView = true

                                        logger.trace("BOUGHT: \(product.vendorProductId). IsPremium: \(isUserPremium)")

                                        isPresented = false

                                        defaults.set(Date().timeIntervalSince1970, forKey: "dateWhenBoughtSubscription")
                                    }
                                },
                                didFailPurchase: { _, error in
                                    alertPaywallError = .init(title: "Purchase failed!", error: error)
                                },
                                didFinishRestore: { _ in
                                    // handle event
                                },
                                didFailRestore: { error in
                                    alertPaywallError = .init(title: "Restore failed!", error: error)
                                },
                                didFailRendering: { error in
                                    isPresented = false
                                    alertPaywallError = .init(title: "Internal Error", error: error)
                                },
                                showAlertItem: $alertPaywallError,
                                showAlertBuilder: { errorItem in
                                    Alert(
                                        title: Text(errorItem.title),
                                        message: Text("\(errorItem.error.localizedDescription)"),
                                        dismissButton: .cancel()
                                    )
                                }
                            )
                    }
                }
                .transition(.move(edge: .bottom))
            } else {
                content
            }
        }
        .onChange(of: isPresented) { newValue in
            if newValue && (paywall == nil || viewConfig == nil) {
                Task {
                    await getPaywall()
                }
            }
        }
        .task {
            if shouldLoadWhenInit {
                await getPaywall()
            }
        }
        .animation(.mainAnimation, value: isPresented)
    }

    func body(content: Content) -> some View {
        contentOrSheet(content: content)
    }

    @ViewBuilder
    private func congratulationView() -> some View {
        PremiumCongratulationView {
            isPresented = false

            delay(0.2) {
                shouldShowCongratulationView = false
            }
        }
        .hCenter()
        .background {
            Palette.accentColor
                .ignoresSafeArea()
        }
        .transition(.opacity.animation(.easeOut(duration: 0.2).delay(0.3)))
    }

    private func getPaywall() async {
        do {
            let paywall = try await Adapty.getPaywall(placementId: placementId, locale: "AdaptyLocale".l)
            let viewConfig = try await AdaptyUI.getViewConfiguration(forPaywall: paywall)

            self.paywall = paywall
            self.viewConfig = viewConfig
        } catch {
            logger.error("getPaywallAndConfig: \(error)")
            alertError = .init(title: "getPaywallAndConfig error!", error: error)
        }
    }
}

extension View {
    func paywall(isPresented: Binding<Bool>, placementId: String, shouldLoadWhenInit: Bool = false) -> some View {
        modifier(
            PaywallViewModifier(
                isPresented: isPresented,
                placementId: placementId,
                shouldLoadWhenInit: shouldLoadWhenInit
            )
        )
    }
}

final class AdaptySubscriptionManager {
    static let shared = AdaptySubscriptionManager()

    private init() { }

    var isPremium: Bool = UserDefaults.standard.bool(forKey: "isPremium") {
        didSet {
            UserDefaults.standard.set(isPremium, forKey: "isPremium")
        }
    }
}
