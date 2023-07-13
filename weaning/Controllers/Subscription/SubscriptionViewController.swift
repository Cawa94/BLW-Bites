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
    @IBOutlet private weak var firstPackageView: PackageView!
    @IBOutlet private weak var secondPackageView: PackageView!
    @IBOutlet private weak var purchaseButton: ButtonView!
    @IBOutlet private weak var purchaseExplanationLabel: UILabel!
    @IBOutlet private weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet private weak var termsConditionsTextView: UITextView!

    var viewModel: SubscriptionViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        infosTextView.attributedText = "SUBSCRIPTION_DESCRIPTION".localized().htmlToAttributedString()

        DispatchQueue.main.async {
            self.viewDidLayoutSubviews()
        }

        if let firstPackage = viewModel?.firstPackage {
            firstPackageView.configureWith(.init(package: firstPackage, tapHandler: {
                self.setFirstAsSelected(true)
            }))
        } else {
            firstPackageView.isHidden = true
        }

        if let secondPackage = viewModel?.secondPackage {
            var discountPercentage: NSDecimalNumber = 0
            if let firstPackage = viewModel?.firstPackage {
                let percentage = secondPackage.storeProduct.pricePerMonth?.dividing(by: firstPackage.storeProduct.pricePerMonth ?? 0)
                    .multiplying(by: 100)
                    .rounding(accordingToBehavior: NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.up, scale: 0,
                                                                          raiseOnExactness: false,
                                                                          raiseOnOverflow: false,
                                                                          raiseOnUnderflow: false,
                                                                          raiseOnDivideByZero: false))
                discountPercentage = NSDecimalNumber(100).subtracting(percentage ?? 0)
            }
            let fullPrice = viewModel?.secondPackage?.id == "$rc_six_month"
                ? (viewModel?.firstPackage?.storeProduct.price ?? 0) * 6
                : (viewModel?.firstPackage?.storeProduct.price ?? 0) * 12
            secondPackageView.configureWith(.init(package: secondPackage,
                                                  hasFreeTrial: viewModel?.hasFreeTrial ?? false,
                                                  percentage: "-\(discountPercentage)%",
                                                  fullPrice: "\(fullPrice) \(viewModel?.secondPackage?.storeProduct.currencyCode ?? "PLN")",
                                                  tapHandler: {
                self.setFirstAsSelected(false)
            }))
        } else {
            secondPackageView.isHidden = true
        }

        setFirstAsSelected(false)

        setTermsConditionsText()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        FirebaseAnalytics.shared.trackScreenView(className: self.className)
    }

    override func viewDidLayoutSubviews() {
        infosTextViewHeightConstraint.constant = infosTextView.contentSize.height
        contentViewHeightConstraint.constant = infosTextViewHeightConstraint.constant
            + 650
    }

    func setFirstAsSelected(_ firstSelected: Bool) {
        viewModel?.firstSelected = firstSelected

        self.firstPackageView.publicContainerView.roundCornersSimplified(
            cornerRadius: .defaultCornerRadius, borderWidth: firstSelected ? 3 : 1, borderColor: .mainColor)
        self.secondPackageView.publicContainerView.roundCornersSimplified(
            cornerRadius: .defaultCornerRadius, borderWidth: firstSelected ? 1 : 3,  borderColor: (viewModel?.hasFreeTrial ?? false) ? .mainColor : .white)

        let explanationLabel: String
        if firstSelected || !(viewModel?.hasFreeTrial ?? false) {
            explanationLabel = "SUBSCRIPTION_CANCEL_ANYTIME".localized()
        } else {
            explanationLabel = String(format: viewModel?.secondPackage?.id == "$rc_annual"
                                      ? "SUBSCRIPTION_PAY_AFTER_TRIAL_1_YEAR".localized()
                                      : "SUBSCRIPTION_PAY_AFTER_TRIAL_6_MONTHS".localized(),
                                      viewModel?.secondPackage?.localizedPriceString ?? "")
        }
        purchaseExplanationLabel.text = explanationLabel

        let buttonTitle = firstSelected || !(viewModel?.hasFreeTrial ?? false)
            ? String(format: "SUBSCRIPTION_PAY_NOW".localized(), firstSelected
                 ? viewModel?.firstPackage?.localizedPriceString ?? ""
                 : viewModel?.secondPackage?.localizedPriceString ?? "")
            : "SUBSCRIPTION_START_FREE_TRIAL".localized()
        purchaseButton.configureWith(.init(title: buttonTitle, fontSize: 20, tapHandler: {
            self.purchase()
        }))
    }

    func purchase() {
        guard let viewModel = viewModel
            else { return }
        if viewModel.firstSelected, let firstPackage = viewModel.firstPackage {
            loadingSpinner.startAnimating()
            RevenueCatService.shared.purchase(firstPackage)
        } else if let secondPackage = viewModel.secondPackage {
            loadingSpinner.startAnimating()
            RevenueCatService.shared.purchase(secondPackage)
        }
    }

    func setTermsConditionsText() {
        termsConditionsTextView.attributedText = "SUBSCRIPTION_TERMS_CONDITIONS".localized()
            .htmlToAttributedString(fontSize: 13)
        termsConditionsTextView.isUserInteractionEnabled = true
        termsConditionsTextView.isEditable = false
        termsConditionsTextView.textAlignment = .center

        termsConditionsTextView.linkTextAttributes = [
            NSAttributedString.Key.font: UIFont.regularFontOf(size: 13),
            NSAttributedString.Key.foregroundColor: UIColor.textColor,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }

}
