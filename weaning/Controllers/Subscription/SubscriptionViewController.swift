//
//  SubscriptionViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 15/3/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import StoreKit

class SubscriptionViewController: UIViewController {

    @IBOutlet private weak var infosTextView: UITextView!
    @IBOutlet private weak var infosTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var productsStackView: UIStackView!

    var viewModel: SubscriptionViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        infosTextView.text = """
        • Access to all the foods
        • Access to all the recipes
        • Access to all the menus
        """
        infosTextViewHeightConstraint.constant = infosTextView.contentSize.height

        FirestoreService.shared.database.collection("subscriptions").getDocuments() { querySnapshot, error in
            self.convertSubscriptionData(querySnapshot, error)
        }
    }

    func convertSubscriptionData(_ querySnapshot: QuerySnapshot?, _ error: Error?) {
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            self.viewModel?.subscriptions.removeAll()
            for document in querySnapshot!.documents {
                self.viewModel?.subscriptions.append(.init(data: document.data()))
            }
            Task.init {
                do {
                    try await loadProducts()
                } catch {
                    debugPrint(error)
                }
            }
        }
    }

    func loadProducts() async throws {
        guard let productIds = (viewModel?.subscriptions.compactMap { $0.id })
            else { return }
        viewModel?.products = try await Product.products(for: productIds)
        for product in viewModel?.products.sorted(by: { $0.price < $1.price }) ?? [] {
            appendProduct(product)
        }
    }

    func appendProduct(_ product: Product) {
        let productView = ProductView()
        productView.configureWith(.init(product: product, tapHandler: {
            // purchase
        }))
        productsStackView.addArrangedSubview(productView)
    }

}
