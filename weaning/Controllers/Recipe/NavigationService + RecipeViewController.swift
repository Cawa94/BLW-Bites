//
//  NavigationService + RecipeViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 1/3/23.
//

import Foundation

extension NavigationService {

    static func recipeViewController(recipeId: String) -> RecipeViewController {
        let controller = RecipeViewController(nibName: RecipeViewController.xibName,
                                              bundle: nil)
        controller.viewModel = RecipeViewModel(recipeId: recipeId)
        return controller
    }

}
