//
//  ProfileViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 20/6/23.
//

import UIKit
import FirebaseAuth
import RevenueCat

class ProfileViewController: UIViewController {

    @IBOutlet private weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = "Hi \(AuthService.shared.currentUser?.displayName ?? "")!"
    }

    @IBAction func logout() {
        Task {
            do {
                Purchases.shared.logOut(completion: { _, _ in
                    Task {
                        do {
                            try Auth.auth().signOut()
                            NavigationService.makeMainRootController()
                        } catch let signOutError as NSError {
                            debugPrint("Error signing out: %@", signOutError)
                        }
                    }
                })
            }
        }
    }

}
