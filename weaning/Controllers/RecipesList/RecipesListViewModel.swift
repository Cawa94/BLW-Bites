//
//  RecipesListViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import FirebaseCore
import FirebaseFirestore

struct RecipesListViewModel {

    var shortRecipes: [ShortRecipe]
    var categorySelected: Int?

    init() {
        shortRecipes = []
    }

}
