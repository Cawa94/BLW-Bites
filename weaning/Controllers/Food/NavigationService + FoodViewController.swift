//
//  NavigationService + FoodViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import Foundation

extension NavigationService {

    static func foodViewController(foodId: String) -> FoodViewController {
        let controller = FoodViewController(nibName: FoodViewController.xibName,
                                            bundle: nil)
        controller.viewModel = FoodViewModel(foodId: foodId)
        return controller
    }

}
