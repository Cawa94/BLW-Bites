//
//  RegistrationViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 20/6/23.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController {

    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nameTextField: CustomTextField!
    @IBOutlet private weak var emailTextField: CustomTextField!
    @IBOutlet private weak var passwordTextField: CustomTextField!
    @IBOutlet private weak var confirmPasswordTextField: CustomTextField!
    @IBOutlet private weak var registerButton: ButtonView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var loadingSpinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()

        nameTextField.configureWith(.init(placeholder: "Name"))
        emailTextField.configureWith(.init(placeholder: "Email"))
        passwordTextField.configureWith(.init(placeholder: "Password"))
        confirmPasswordTextField.configureWith(.init(placeholder: "Confirm Password"))
        registerButton.configureWith(.init(title: "Register", tapHandler: {
            self.register()
        }))
    }

    func register() {
        guard fieldsAreValid()
            else { return }
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        loadingSpinner.startAnimating()
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            self.loadingSpinner.stopAnimating()
            if AuthService.shared.isLoggedIn {
                AuthService.shared.updateName(name)
                RevenueCatService.shared.loginWithId(AuthService.shared.currentUser?.uid)
                debugPrint("USER EMAIL: \(AuthService.shared.currentUser?.email) ID: \(AuthService.shared.currentUser?.uid)")
                self.showMessageLabel("Your account has been created!", color: .mainColor)
                NavigationService.willPresentSubscription = true
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    NavigationService.makeMainRootController()
                }
            } else if let error = error as? NSError {
                self.showMessageLabel(error.localizedFirebaseAuthMessage, color: .red)
                debugPrint("ERROR: \(error.localizedFirebaseAuthMessage)")
            }
        }
    }

    @IBAction func backToLogin() {
        NavigationService.popViewController()
    }

    func fieldsAreValid() -> Bool {
        var valid = true
        if nameTextField.text?.isEmpty ?? true {
            nameTextField.underline(color: .red)
            valid = false
        }
        if emailTextField.text?.isEmpty ?? true {
            emailTextField.underline(color: .red)
            valid = false
        }
        if passwordTextField.text?.isEmpty ?? true {
            passwordTextField.underline(color: .red)
            valid = false
        }
        if confirmPasswordTextField.text?.isEmpty ?? true {
            confirmPasswordTextField.underline(color: .red)
            valid = false
        }
        if passwordTextField.text != confirmPasswordTextField.text {
            passwordTextField.underline(color: .red)
            confirmPasswordTextField.underline(color: .red)
            showMessageLabel("The 2 passwords are different", color: .red)
            valid = false
        }
        return valid
    }

    func showMessageLabel(_ text: String, color: UIColor) {
        messageLabel.textColor = color
        messageLabel.text = text
        messageLabel.isHidden = false
    }

}

extension RegistrationViewController: UITextFieldDelegate {

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
