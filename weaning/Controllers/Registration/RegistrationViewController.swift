//
//  RegistrationViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 20/6/23.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController {

    @IBOutlet private weak var emailTextField: CustomTextField!
    @IBOutlet private weak var passwordTextField: CustomTextField!
    @IBOutlet private weak var confirmPasswordTextField: CustomTextField!
    @IBOutlet private weak var registerButton: ButtonView!
    @IBOutlet private weak var successLabel: UILabel!
    @IBOutlet private weak var loadingSpinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()

        emailTextField.configureWith(.init(placeholder: "Email"))
        passwordTextField.configureWith(.init(placeholder: "Password"))
        confirmPasswordTextField.configureWith(.init(placeholder: "Confirm Password"))
        registerButton.configureWith(.init(title: "Register", tapHandler: {
            self.register()
        }))
    }

    func register() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        loadingSpinner.startAnimating()
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            self.loadingSpinner.stopAnimating()
            if AuthService.shared.isLoggedIn {
                debugPrint("USER CREATED")
                self.successLabel.isHidden = false
                NavigationService.willPresentSubscription = true
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    NavigationService.makeMainRootController()
                }
            } else {
                debugPrint("ERROR")
            }
        }
    }

    @IBAction func backToLogin() {
        NavigationService.popViewController()
    }

}
