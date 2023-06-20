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
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        loadingSpinner.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            self.loadingSpinner.stopAnimating()
            if AuthService.shared.isLoggedIn {
                debugPrint("LOGIN CORRECTLY")
                NavigationService.makeMainRootController()
            } else {
                debugPrint("ERROR")
            }
        }
    }

    @IBAction func openRegistration() {
        NavigationService.push(viewController: NavigationService.registrationViewController())
    }

    @IBAction func openResetPassword() {
        NavigationService.push(viewController: NavigationService.resetPasswordViewController())
    }

}
