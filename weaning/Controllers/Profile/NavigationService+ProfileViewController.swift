//
//  NavigationService+ProfileViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 20/6/23.
//

import UIKit

extension NavigationService {

    static func profileViewController() -> UINavigationController {
        let controller = ProfileViewController(nibName: ProfileViewController.xibName,
                                               bundle: nil).embedInNavigationController()
        return controller
    }

}
