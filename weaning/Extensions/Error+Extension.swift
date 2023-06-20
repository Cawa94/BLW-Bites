//
//  Error+Extension.swift
//  weaning
//
//  Created by Yuri Cavallin on 20/6/23.
//

import FirebaseAuth

extension NSError {

    var localizedFirebaseAuthMessage: String {
        let errCode = AuthErrorCode(_nsError: self).code
        switch errCode {
        case .invalidEmail:
            return "The email is invalid"
        case .operationNotAllowed:
            return "The operation is not allowedt"
        case .userDisabled:
            return "The user account has been disable"
        case .wrongPassword:
            return "The password inserted is wrong"
        case .emailAlreadyInUse:
            return "This email has already been used"
        case .weakPassword:
            return "The password is too weak"
        case .userNotFound:
            return "User account not found"
        case .requiresRecentLogin:
            return "Login again in order to continue"
        default:
            return self.localizedDescription
        }
    }

}
