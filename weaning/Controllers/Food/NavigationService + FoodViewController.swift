//
//  NavigationService + FoodViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import Foundation
import UIKit

extension NavigationService {

    static func foodViewController(foodId: String, cellFavoriteImageView: UIImageView? = nil) -> FoodViewController {
        let controller = FoodViewController(nibName: FoodViewController.xibName,
                                            bundle: nil)
        controller.viewModel = FoodViewModel(foodId: foodId,
                                             cellFavoriteImageView: cellFavoriteImageView)
        return controller
    }

}
