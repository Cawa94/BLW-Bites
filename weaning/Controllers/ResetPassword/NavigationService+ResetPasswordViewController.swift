//
//  NavigationService+ResetPasswordViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 20/6/23.
//

import Foundation

extension NavigationService {

    static func resetPasswordViewController() -> ResetPasswordViewController {
        let controller = ResetPasswordViewController(nibName: ResetPasswordViewController.xibName,
                                                     bundle: nil)
        return controller
    }

}
