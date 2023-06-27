//
//  AuthService.swift
//  weaning
//
//  Created by Yuri Cavallin on 20/6/23.
//

import FirebaseAuth
import RevenueCat

class AuthService {

    static let shared = AuthService()

    private init() {
        Auth.auth().useAppLanguage()
    }

    var isLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }

    var currentUser: User? {
        Auth.auth().currentUser
    }

    func updateName(_ name: String) {
        let changeRequest = currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { _ in
            
        }
    }

    func logout() {
        Purchases.shared.logOut(completion: { _, _ in
            do {
                try Auth.auth().signOut()
                RevenueCatService.shared.getOfferingsAndCustomerInfo()
            } catch let signOutError as NSError {
                NavigationService.presentAlertWith(title: "ALERT_ERROR".localized(),
                                                   message: signOutError.localizedDescription,
                                                   confirmAction: {})
            }
        })
    }

    func deleteUser() {
        currentUser?.delete { error in
            if let error = error {
                NavigationService.presentAlertWith(title: "ALERT_ERROR".localized(),
                                                   message: error.localizedDescription,
                                                   confirmAction: {})
            } else {
                NavigationService.presentAlertWith(title: "ALERT_SUCCESS".localized(),
                                                   message: "ALERT_ACCOUNT_DELETED".localized(),
                                                   confirmAction: {
                    AuthService.shared.logout()
                })
            }
        }
    }

}
