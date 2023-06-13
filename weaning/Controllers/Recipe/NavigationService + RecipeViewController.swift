//
//  NavigationService + RecipeViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 1/3/23.
//

import UIKit

extension NavigationService {

    static func recipeViewController(recipeId: String, recipe: Recipe?, cellFavoriteImageView: UIImageView? = nil) -> RecipeViewController {
        let controller = RecipeViewController(nibName: RecipeViewController.xibName,
                                              bundle: nil)
        controller.viewModel = RecipeViewModel(recipeId: recipeId,
                                               recipe: recipe,
                                               cellFavoriteImageView: cellFavoriteImageView)
        return controller
    }

}
