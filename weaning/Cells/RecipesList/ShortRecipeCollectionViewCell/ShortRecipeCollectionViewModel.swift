//
//  ShortRecipeCollectionViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 17/5/23.
//

import Foundation

struct ShortRecipeCollectionViewModel {

    let shortRecipe: ShortRecipe
    let recipe: Recipe?
    let inHomepage: Bool

    init(shortRecipe: ShortRecipe, recipe: Recipe?, inHomepage: Bool = false) {
        self.shortRecipe = shortRecipe
        self.recipe = recipe
        self.inHomepage = inHomepage
    }

}
