//
//  ProfileViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 20/6/23.
//

import UIKit
import FirebaseAuth
import RevenueCat

class ProfileViewController: UIViewController {

    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var activeSubscriptionLabel: UILabel!
    @IBOutlet private weak var nextPaymentLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var restoreOrCancelButton: UIButton!
    @IBOutlet private weak var cancelAccountButton: UIButton!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var subscribeButton: ButtonView!
    @IBOutlet private weak var subscribeButtonHeighConstraint: NSLayoutConstraint!
    @IBOutlet private weak var restoreSpinner: UIActivityIndicatorView!
    @IBOutlet private weak var logoutSpinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = AuthService.shared.currentUser?.displayName ?? ""
        emailLabel.text = AuthService.shared.currentUser?.email ?? ""

        if RevenueCatService.shared.hasUnlockedPro {
            if let expirationDate = RevenueCatService.shared.proVersionEntitlement?.expirationDate?.toString {
                dateLabel.text = expirationDate
            } else {
                dateLabel.isHidden = true
                nextPaymentLabel.text = nil
            }
            subscribeButton.isHidden = true
            subscribeButtonHeighConstraint.constant = 0
            activeSubscriptionLabel.font = .regularFontOf(size: 18)
            activeSubscriptionLabel.text = "PROFILE_PRO_VERSION".localized()
            restoreOrCancelButton.setAttributedTitle("PROFILE_CANCEL_SUBSCRIPTION".localized())
        } else {
            dateLabel.isHidden = true
            nextPaymentLabel.text = nil
            subscribeButton.configureWith(.init(title: "PROFILE_SUBSCRIBE_NOW".localized(), tapHandler: {
                NavigationService.push(viewController: NavigationService.subscriptionViewController())
            }))
            subscribeButtonHeighConstraint.constant = 60
            activeSubscriptionLabel.font = .regularFontOf(size: 16)
            activeSubscriptionLabel.text = "PROFILE_NO_SUBSCRIPTION".localized()
            restoreOrCancelButton.setAttributedTitle("PROFILE_RESTORE_PURCHASE".localized())
        }

        DispatchQueue.main.async {
            self.viewDidLayoutSubviews()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        FirebaseAnalytics.shared.trackScreenView(className: self.className)
    }

    override func viewDidLayoutSubviews() {
        imageContainerView.roundCornersSimplified(cornerRadius: imageContainerView.frame.height/2, borderWidth: 1.5, borderColor: .mainColor)
    }

    @IBAction func restoreOrCancel() {
        if RevenueCatService.shared.hasUnlockedPro {
            guard let managementUrl = RevenueCatService.shared.customerInfo?.managementURL
                else { return }
            if UIApplication.shared.canOpenURL(managementUrl as URL) {
                UIApplication.shared.open(managementUrl as URL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.open(managementUrl as URL, options: [:], completionHandler: nil)
            }
        } else {
            restoreSpinner.startAnimating()
            RevenueCatService.shared.restorePurchase()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                self.restoreSpinner.stopAnimating()
            }
        }
    }

    @IBAction func cancelAccount() {
        NavigationService.presentAlertWith(title: "ALERT_WARNING".localized(),
                                           message: "ALERT_CONFIRM_DELETE_ACCOUNT".localized(),
                                           isDestructive: true,
                                           confirmText: "COMMON_YES".localized(),
                                           confirmAction: {
            AuthService.shared.deleteUser()
        }, showCancelAction: true)
    }

    @IBAction func logout() {
        logoutSpinner.startAnimating()
        AuthService.shared.logout()
    }

}
