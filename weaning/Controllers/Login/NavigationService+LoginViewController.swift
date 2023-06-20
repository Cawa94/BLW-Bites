//
//  NavigationService+LoginViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 20/6/23.
//

import UIKit

extension NavigationService {

    static func loginViewController() -> UINavigationController {
        let controller = LoginViewController(nibName: LoginViewController.xibName,
                                             bundle: nil).embedInNavigationController()
        return controller
    }

}
