//
//  NavigationService+MenuViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/3/23.
//

import Foundation

extension NavigationService {

    static func menuViewController(menuId: String, menuName: String) -> MenuViewController {
        let controller = MenuViewController(nibName: MenuViewController.xibName,
                                            bundle: nil)
        controller.viewModel = MenuViewModel(menuId: menuId, menuName: menuName)
        return controller
    }

}
