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
import RevenueCat

class SubscriptionViewController: UIViewController {

    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var infosTextView: UITextView!
    @IBOutlet private weak var infosTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var productsStackView: UIStackView!

    var viewModel: SubscriptionViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.viewDidLayoutSubviews()
        }

        for package in RevenueCatService.shared.packages ?? [] {
            appendProduct(package)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        FirebaseAnalytics.shared.trackScreenView(className: self.className)
    }

    override func viewDidLayoutSubviews() {
        infosTextViewHeightConstraint.constant = infosTextView.contentSize.height
        contentViewHeightConstraint.constant = infosTextViewHeightConstraint.constant
            + 500
    }

    func appendProduct(_ package: Package) {
        let productView = PackageView()
        productView.configureWith(.init(package: package, tapHandler: {
            RevenueCatService.shared.purchase(package)
        }))
        productsStackView.addArrangedSubview(productView)
    }

    @IBAction func restorePurchas() {
        RevenueCatService.shared.restorePurchas()
    }

}
