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
    var customerInfo: CustomerInfo?

    private init() { }

    func configure() {
        // Purchases.logLevel = .debug

        Purchases.configure(withAPIKey: .revenueCatPublicKey)
        getCurrentOfferings()
        getCustomerInfo()
    }

    func getCustomerInfo() {
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            self.customerInfo = customerInfo
            NavigationService.makeMainRootController()
        }
    }

    func getCurrentOfferings() {
        Purchases.shared.getOfferings { (offerings, error) in
            if let packages = offerings?.current?.availablePackages {
                self.packages = packages
            }
        }
    }

    func purchase(_ package: Package) {
        Purchases.shared.purchase(package: package) { (transaction, customerInfo, error, userCancelled) in
            self.handlePurchasResponse(customerInfo: customerInfo, error: error)
        }
    }

    func restorePurchas() {
        Purchases.shared.restorePurchases { customerInfo, error in
            self.handlePurchasResponse(customerInfo: customerInfo, error: error)
        }
    }

    func handlePurchasResponse(customerInfo: CustomerInfo?, error: PublicError?) {
        if customerInfo?.entitlements["Pro Version"]?.isActive == true {
            debugPrint("YOU GOT THE PRO VERSION!")
            self.customerInfo = customerInfo
            DispatchQueue.main.async {
                NavigationService.makeMainRootController()
            }
        } else if let error = error as? RevenueCat.ErrorCode {
            debugPrint(error.errorCode)
            debugPrint(error.errorUserInfo)
            
            switch error {
            case .purchaseNotAllowedError:
                debugPrint("Purchases not allowed on this device.")
            case .purchaseInvalidError:
                debugPrint("Purchase invalid, check payment source.")
            default: break
            }
        } else {
          // Error is a different type
        }
    }

    var hasUnlockedPro: Bool {
        /*#if DEBUG
            return true
        #else*/
            return customerInfo?.entitlements["Pro Version"]?.isActive ?? false
        //#endif
    }

}
