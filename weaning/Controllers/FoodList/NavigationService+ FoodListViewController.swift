//
//  NavigationService+FoodListViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import Foundation

extension NavigationService {

    static func foodListViewController() -> FoodListViewController {
        let controller = FoodListViewController(nibName: FoodListViewController.xibName,
                                                bundle: nil)
        controller.viewModel = FoodListViewModel()
        return controller
    }

}
