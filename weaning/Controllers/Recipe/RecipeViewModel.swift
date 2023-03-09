//
//  RecipeViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 1/3/23.
//

import Foundation

struct RecipeViewModel {

    let recipeId: String
    var recipe: Recipe?

    init(recipeId: String) {
        self.recipeId = recipeId
    }

}
