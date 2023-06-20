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

    func logout() async {
        do {
            try await Purchases.shared.logOut()
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            debugPrint("Error signing out: %@", signOutError)
        }
    }

    func deleteUser() {
        currentUser?.delete { error in
            if let error = error {
                // An error happened.
            } else {
                // Account deleted.
            }
        }
    }

}
