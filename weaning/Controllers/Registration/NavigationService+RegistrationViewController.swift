//
//  NavigationService+RegistrationViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 20/6/23.
//

import Foundation

extension NavigationService {

    static func registrationViewController() -> RegistrationViewController {
        let controller = RegistrationViewController(nibName: RegistrationViewController.xibName,
                                                    bundle: nil)
        return controller
    }

}
