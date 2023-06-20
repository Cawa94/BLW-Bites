//
//  LoginViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 20/6/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet private weak var emailTextField: CustomTextField!
    @IBOutlet private weak var passwordTextField: CustomTextField!
    @IBOutlet private weak var loginButton: ButtonView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var loadingSpinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()

        emailTextField.configureWith(.init(placeholder: "Email"))
        passwordTextField.configureWith(.init(placeholder: "Password"))
        loginButton.configureWith(.init(title: "Login", tapHandler: {
            self.login()
        }))
    }

    func login() {
        guard fieldsAreValid()
            else { return }
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        loadingSpinner.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            self.loadingSpinner.stopAnimating()
            if AuthService.shared.isLoggedIn {
                RevenueCatService.shared.loginWithId(AuthService.shared.currentUser?.uid)
                debugPrint("USER EMAIL: \(AuthService.shared.currentUser?.email) ID: \(AuthService.shared.currentUser?.uid)")
                NavigationService.makeMainRootController()
            } else if let error = error as? NSError {
                self.messageLabel.text = error.localizedFirebaseAuthMessage
                self.messageLabel.isHidden = false
                debugPrint("ERROR: \(error.localizedFirebaseAuthMessage)")
            }
        }
    }

    @IBAction func openRegistration() {
        NavigationService.push(viewController: NavigationService.registrationViewController())
    }

    @IBAction func openResetPassword() {
        NavigationService.push(viewController: NavigationService.resetPasswordViewController())
    }

    func fieldsAreValid() -> Bool {
        var valid = true
        if emailTextField.text?.isEmpty ?? true {
            emailTextField.underline(color: .red)
            valid = false
        }
        if passwordTextField.text?.isEmpty ?? true {
            passwordTextField.underline(color: .red)
            valid = false
        }
        return valid
    }

}

extension LoginViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let customTextField = textField as? CustomTextField {
            customTextField.underline()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return false
    }

}
