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

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()

        emailTextField.configureWith(.init(placeholder: "Email"))
        sendEmailButton.configureWith(.init(title: "Send email", tapHandler: {
            self.sendEmail()
        }))
    }

    func sendEmail() {
        let email = emailTextField.text ?? ""
        AuthService.shared.sendResetPasswordTo(email: email)
    }

    @IBAction func openRegistration() {
        NavigationService.push(viewController: NavigationService.registrationViewController())
    }

}
