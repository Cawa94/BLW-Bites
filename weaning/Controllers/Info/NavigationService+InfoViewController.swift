//
//  NavigationService+InfoViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 21/3/23.
//

import Foundation

extension NavigationService {

    static func infoViewController() -> InfoViewController {
        let controller = InfoViewController(nibName: InfoViewController.xibName,
                                            bundle: nil)
        return controller
    }

}
