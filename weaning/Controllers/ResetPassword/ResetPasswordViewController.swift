//
//  ResetPasswordViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 20/6/23.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {

    @IBOutlet private weak var emailTextField: CustomTextField!
    @IBOutlet private weak var sendEmailButton: ButtonView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var loadingSpinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        addKeyboardSettings()

        emailTextField.configureWith(.init(placeholder: "AUTH_EMAIL".localized()))
        sendEmailButton.configureWith(.init(title: "RESET_PASSWORD_SEND_EMAIL".localized(), tapHandler: {
            self.sendEmail()
        }))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        FirebaseAnalytics.shared.trackScreenView(className: self.className)
    }

    func sendEmail() {
        guard fieldsAreValid()
            else { return }
        let email = emailTextField.text ?? ""

        loadingSpinner.startAnimating()
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            self.loadingSpinner.stopAnimating()
            if let error = error as? NSError {
                self.showMessageLabel(error.localizedFirebaseAuthMessage, color: .red)
                debugPrint("ERROR: \(error.localizedFirebaseAuthMessage)")
            } else {
                self.showMessageLabel("RESET_PASSWORD_EMAIL_SENT".localized(), color: .mainColor)
            }
        }
    }

    @IBAction func openRegistration() {
        NavigationService.push(viewController: NavigationService.registrationViewController())
    }

    func fieldsAreValid() -> Bool {
        var valid = true
        if emailTextField.text?.isEmpty ?? true {
            emailTextField.underline(color: .red)
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

extension ResetPasswordViewController: UITextFieldDelegate {

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
        textField.resignFirstResponder()

        return false
    }

}
