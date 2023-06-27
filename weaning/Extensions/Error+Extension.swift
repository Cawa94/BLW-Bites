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
            return "AUTH_ERROR_INVALID_EMAIL".localized()
        case .operationNotAllowed:
            return "AUTH_ERROR_OPERATION_NOT_ALLOWED".localized()
        case .userDisabled:
            return "AUTH_ERROR_USER_DISABLED".localized()
        case .wrongPassword:
            return "AUTH_ERROR_WRONG_PASSWORD".localized()
        case .emailAlreadyInUse:
            return "AUTH_ERROR_EMAIL_ALREADY_USED".localized()
        case .weakPassword:
            return "AUTH_ERROR_WEAK_PASSWORD".localized()
        case .userNotFound:
            return "AUTH_ERROR_USER_NOT_FOUND".localized()
        case .requiresRecentLogin:
            return "AUTH_ERROR_REQUIRES_RECENT_LOGIN".localized()
        default:
            return self.localizedDescription
        }
    }

}
