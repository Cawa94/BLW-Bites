//
//  ProfileViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 20/6/23.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logout() {
        AuthService.shared.logout()
        NavigationService.makeMainRootController()
    }

}
