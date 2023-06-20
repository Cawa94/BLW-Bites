//
//  PurchaseManager.swift
//  weaning
//
//  Created by Yuri Cavallin on 20/3/23.
//

import Foundation
import StoreKit
/*
class PurchaseManager: ObservableObject {

    static let shared = PurchaseManager()

    var products: [Product]?
    private(set) var purchasedProductIDs = Set<String>()
    private var updates: Task<Void, Never>? = nil

    init() {
        updates = observeTransactionUpdates()
    }

    deinit {
        updates?.cancel()
    }

    func loadProducts(productIds: [String]) async throws {
        self.products = try await Product.products(for: productIds)
    }

    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()

        switch result {
        case .success(let verificationResult):
            switch verificationResult {
            case .verified(let transaction):
                // Give the user access to purchased content.
                // Complete the transaction after providing
                // the user access to the content.
                debugPrint("ALL GOOD")
                await transaction.finish()
                await self.updatePurchasedProducts()
                DispatchQueue.main.async {
                    NavigationService.makeMainRootController()
                }
            case .unverified(_, _):
                // Handle unverified transactions based
                // on your business model.
                debugPrint("UNVERIFIED")
                break
            }
        case .pending:
            // The purchase requires action from the customer.
            // If the transaction completes,
            // it's available through Transaction.updates.
            debugPrint("PENDING")
            break
        case .userCancelled:
            // The user canceled the purchase.
            debugPrint("USER CANCELLED")
            break
        @unknown default:
            break
        }
    }

    var hasUnlockedPro: Bool {
        /*#if DEBUG
            return true
        #else*/
            return !self.purchasedProductIDs.isEmpty
        //#endif
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
    }

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await verificationResult in Transaction.updates {
                // Using verificationResult directly would be better
                // but this way works for this tutorial
                await self.updatePurchasedProducts()
            }
        }
    }

    func restorePurchase() async throws {
        do {
            try await AppStore.sync()
        } catch {
            debugPrint(error)
        }
    }

}
*/
