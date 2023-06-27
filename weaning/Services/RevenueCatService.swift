//
//  RevenueCatService.swift
//  weaning
//
//  Created by Yuri Cavallin on 19/6/23.
//

import RevenueCat

private extension String {

    static let revenueCatPublicKey = "appl_EtzjnobPErqFTYbVhGZjEEqSzuL"

}

class RevenueCatService {

    static let shared = RevenueCatService()

    var packages: [Package]?
    var hasFreeTrial = false
    var customerInfo: CustomerInfo?

    private init() { }

    func configure() {
        Purchases.logLevel = .warn

        if let userId = AuthService.shared.currentUser?.uid {
            Purchases.configure(withAPIKey: .revenueCatPublicKey, appUserID: userId)
        } else {
            Purchases.configure(withAPIKey: .revenueCatPublicKey)
        }
        getOfferingsAndCustomerInfo()
    }

    var proVersionEntitlement: EntitlementInfo? {
        customerInfo?.entitlements["Pro Version"]
    }

    var hasUnlockedPro: Bool {
        /*#if DEBUG
            return true
        #else*/
            return proVersionEntitlement?.isActive ?? false
        //#endif
    }

    func getOfferingsAndCustomerInfo() {
        getCurrentOfferings()
        getCustomerInfo()
    }

    func getCustomerInfo() {
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            self.customerInfo = customerInfo
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                NavigationService.makeMainRootController()
            }
        }
    }

    func associateToRevenueCatUserWith(_ uid: String?) {
        guard let userId = uid
            else { return }
        Purchases.shared.logIn(userId) { (customerInfo, created, error) in
            self.customerInfo = customerInfo
            self.setUserProperties()
        }
    }

    func getCurrentOfferings() {
        Purchases.shared.getOfferings { (offerings, error) in
            if let packages = offerings?.current?.availablePackages {
                self.packages = packages
                for package in packages where package.id == "$rc_six_month" {
                    Purchases.shared.checkTrialOrIntroDiscountEligibility(product: package.storeProduct) { eligibility in
                        if eligibility == .eligible {
                            self.hasFreeTrial = true
                        }
                    }
                }
            }
        }
    }

    func purchase(_ package: Package) {
        Purchases.shared.purchase(package: package) { (transaction, customerInfo, error, userCancelled) in
            self.handlePurchasResponse(customerInfo: customerInfo, error: error)
        }
    }

    func restorePurchase() {
        Purchases.shared.restorePurchases { customerInfo, error in
            self.handlePurchasResponse(customerInfo: customerInfo, error: error)
        }
    }

    func handlePurchasResponse(customerInfo: CustomerInfo?, error: PublicError?) {
        if customerInfo?.entitlements["Pro Version"]?.isActive == true {
            NavigationService.presentAlertWith(title: "ALERT_SUCCESS".localized(),
                                               message: "ALERT_UNLOCKED_PRO_VERSION".localized(),
                                               confirmAction: {
                self.customerInfo = customerInfo
                DispatchQueue.main.async {
                    NavigationService.makeMainRootController()
                }
            })
        } else if let error = error as? RevenueCat.ErrorCode {
            debugPrint(error.errorCode)
            debugPrint(error.errorUserInfo)
            
            let errorMessage: String
            switch error {
            case .purchaseNotAllowedError:
                errorMessage = "ALERT_PURCHASE_NOT_ALLOWED".localized()
            case .purchaseInvalidError:
                errorMessage = "ALERT_PURCHASE_INVALID".localized()
            default:
                errorMessage = "ALERT_GENERAL_ERROR".localized()
            }
            NavigationService.presentAlertWith(title: "ALERT_ERROR".localized(),
                                               message: errorMessage,
                                               confirmAction: {})
        } else {
            NavigationService.presentAlertWith(title: "ALERT_WARNING".localized(),
                                               message: "ALERT_GENERAL_ERROR".localized(),
                                               confirmAction: {})
        }
    }

    func setUserProperties() {
        Purchases.shared.attribution.setAttributes(["$displayName" : AuthService.shared.currentUser?.displayName ?? "",
                                                    "$email" : AuthService.shared.currentUser?.email ?? ""])
    }

}
