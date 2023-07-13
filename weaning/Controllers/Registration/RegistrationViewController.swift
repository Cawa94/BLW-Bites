//
//  RegistrationViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 20/6/23.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController {

    @IBOutlet private weak var mainScrollView: UIScrollView!
    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nameTextField: CustomTextField!
    @IBOutlet private weak var emailTextField: CustomTextField!
    @IBOutlet private weak var passwordTextField: CustomTextField!
    @IBOutlet private weak var confirmPasswordTextField: CustomTextField!
    @IBOutlet private weak var registerButton: ButtonView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet private weak var termsConditionsTextView: UITextView!

    override var internalScrollView: UIScrollView {
        mainScrollView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addKeyboardSettings()

        nameTextField.configureWith(.init(placeholder: "REGISTRATION_NAME".localized()))
        emailTextField.configureWith(.init(placeholder: "AUTH_EMAIL".localized()))
        passwordTextField.configureWith(.init(placeholder: "AUTH_PASSWORD".localized()))
        confirmPasswordTextField.configureWith(.init(placeholder: "REGISTRATION_CONFIRM_PASSWORD".localized()))
        registerButton.configureWith(.init(title: "REGISTRATION_BUTTON".localized(), tapHandler: {
            self.register()
        }))

        setTermsConditionsText()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        FirebaseAnalytics.shared.trackScreenView(className: self.className)
    }

    func register() {
        guard fieldsAreValid()
            else { return }
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        loadingSpinner.startAnimating()
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if AuthService.shared.isLoggedIn {
                AuthService.shared.updateName(name)
                RevenueCatService.shared.associateToRevenueCatUserWith(AuthService.shared.currentUser?.uid)
                self.showMessageLabel("REGISTRATION_ACCOUNT_CREATED".localized(), color: .mainColor)
                NavigationService.willPresentSubscription = true
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    RevenueCatService.shared.getOfferingsAndCustomerInfo()
                }
            } else if let error = error as? NSError {
                self.loadingSpinner.stopAnimating()
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
            showMessageLabel("REGISTRATION_PASSWORD_DIFFERENT".localized(), color: .red)
            valid = false
        }
        return valid
    }

    func showMessageLabel(_ text: String, color: UIColor) {
        messageLabel.textColor = color
        messageLabel.text = text
        messageLabel.isHidden = false
    }

    func setTermsConditionsText() {
        termsConditionsTextView.attributedText = "REGISTRATION_TERMS_CONDITIONS".localized()
            .htmlToAttributedString(fontSize: 13)
        termsConditionsTextView.isUserInteractionEnabled = true
        termsConditionsTextView.isEditable = false
        termsConditionsTextView.textAlignment = .center

        termsConditionsTextView.linkTextAttributes = [
            NSAttributedString.Key.font: UIFont.regularFontOf(size: 13),
            NSAttributedString.Key.foregroundColor: UIColor.textColor,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }

}

extension RegistrationViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let customTextField = textField as? CustomTextField {
            customTextField.underline(color: .mainColor)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
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

extension RegistrationViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
           //Check your url whether it is privacy policy or terms and do accordigly
            return true
        }

}
