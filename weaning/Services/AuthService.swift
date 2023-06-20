//
//  AuthService.swift
//  weaning
//
//  Created by Yuri Cavallin on 20/6/23.
//

import FirebaseAuth

class AuthService {

    static let shared = AuthService()

    private init() { }

    var isLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }

    var currentUser: User? {
        Auth.auth().currentUser
    }

    func sendResetPasswordTo(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            
        }
    }

    func logout() {
        // Dismiss also the RevenueCat user
        do {
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
