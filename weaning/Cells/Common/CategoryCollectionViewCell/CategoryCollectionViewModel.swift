//
//  CategoryCollectionViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 17/5/23.
//

import Foundation

struct CategoryCollectionViewModel {

    let foodCategory: FoodCategory?
    let recipeCategory: RecipeCategory?
    let isFavorites: Bool

    init(foodCategory: FoodCategory? = nil,
         recipeCategory: RecipeCategory? = nil,
         isFavorites: Bool) {
        self.foodCategory = foodCategory
        self.recipeCategory = recipeCategory
        self.isFavorites = isFavorites
    }

}
