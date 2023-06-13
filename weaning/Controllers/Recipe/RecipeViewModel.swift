//
//  RecipeViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 1/3/23.
//

import UIKit

struct RecipeViewModel {

    let recipeId: String
    var recipe: Recipe?
    var cellFavoriteImageView: UIImageView?

    init(recipeId: String,
         recipe: Recipe?,
         cellFavoriteImageView: UIImageView?) {
        self.recipeId = recipeId
        self.recipe = recipe
        self.cellFavoriteImageView = cellFavoriteImageView
    }

}
