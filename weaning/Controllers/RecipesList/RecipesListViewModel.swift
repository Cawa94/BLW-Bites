//
//  RecipesListViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import FirebaseCore
import FirebaseFirestore

struct RecipesListViewModel {

    var recipes: [Recipe]
    var categorySelected: Int?

    init() {
        recipes = []
    }

    var visibleRecipes: [Recipe] {
        recipes.filter { !($0.isHidden ?? false) }
    }

}
