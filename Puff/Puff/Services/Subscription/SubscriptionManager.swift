//
//  SubscriptionManager.swift
//  Puff
//
//  Created by Никита Куприянов on 27.09.2024.
//

import SwiftUI
import StoreKit

@MainActor
class SubscriptionsManager: NSObject, ObservableObject {
    let productIDs: [String] = ["com.quitvaping.month", "com.quitvaping.month1"]
    var purchasedProductIDs: Set<String> = []

    @Published var products: [Product] = []

    @AppStorage("isPremium") var isPremium: Bool = false

    private var updates: Task<Void, Never>? = nil

    override init() {
        super.init()
        self.updates = observeTransactionUpdates()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        updates?.cancel()
    }

    func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await _ in Transaction.updates {
                await self.updatePurchasedProducts()
            }
        }
    }
}

// MARK: StoreKit2 API
extension SubscriptionsManager {
    func loadProducts() async {
        do {
            self.products = try await Product.products(for: productIDs)
        } catch {
            print("Failed to fetch products!")
        }
    }

    func buyProduct(withTrial: Bool, callback: @escaping (String?) -> Void) async {
        do {
            let result = try await products[withTrial ? 1 : 0].purchase()

            switch result {
            case let .success(.verified(transaction)):
                // Successful purhcase
                await transaction.finish()
                await self.updatePurchasedProducts()
                callback(nil)
            case let .success(.unverified(_, error)):
                // Successful purchase but transaction/receipt can't be verified
                // Could be a jailbroken phone
                print("Unverified purchase. Might be jailbroken. Error: \(error)")
                break
            case .pending:
                // Transaction waiting on SCA (Strong Customer Authentication) or
                // approval from Ask to Buy
                break
            case .userCancelled:
                print("User cancelled!")
                break
            @unknown default:
                print("Failed to purchase the product!")
                break
            }
        } catch {
            callback(error.localizedDescription)
        }
    }

    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }

            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }

        self.isPremium = !self.purchasedProductIDs.isEmpty
    }

    func restorePurchases(callback: @escaping (String?) -> Void) async {
        do {
            try await AppStore.sync()

            callback(nil)
        } catch {
            callback(error.localizedDescription)
        }
    }
}

extension SubscriptionsManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {

    }

    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
}
