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

    @State private var paywall: AdaptyPaywall?
    @State private var viewConfig: AdaptyUI.LocalizedViewConfiguration?

    @AppStorage("isPremium") var isPremium: Bool = false

    @State private var shouldShowCongratulationView: Bool = false

    @State private var alertError: IdentifiableErrorWrapper?
    @State private var alertPaywallError: IdentifiableErrorWrapper?

    @ViewBuilder
    func contentOrSheet(content: Content) -> some View {
        ZStack {
            if let paywall, let viewConfig {
                content
                    .paywall(
                        isPresented: $isPresented,
                        paywall: paywall,
                        viewConfiguration: viewConfig,
                        didFinishPurchase: { product, info in
                            isPremium = info.profile.accessLevels["premium"]?.isActive ?? false

                            isPresented = false

                            logger.trace("BOUGHT: \(product.vendorProductId). IsPremium: \(isPremium)")
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

            } else {
                content
            }
        }
    }

    func body(content: Content) -> some View {
        contentOrSheet(content: content)
            .task {
                do {
                    let paywall = try await Adapty.getPaywall(placementId: placementId)
                    let viewConfig = try await AdaptyUI.getViewConfiguration(forPaywall: paywall)

                    self.paywall = paywall
                    self.viewConfig = viewConfig
                } catch {
                    logger.error("getPaywallAndConfig: \(error)")
                    alertError = .init(title: "getPaywallAndConfig error!", error: error)
                }
            }
//            .animation(.easeOut(duration: 0.35), value: shouldShowCongratulationView)
//            .onChange(of: isPremium) { newValue in
//                if newValue {
//                    shouldShowCongratulationView = true
//                }
//            }
    }
}

extension View {
    func paywall(isPresented: Binding<Bool>, placementId: String) -> some View {
        modifier(
            PaywallViewModifier(
                isPresented: isPresented,
                placementId: placementId
            )
        )
    }
}
