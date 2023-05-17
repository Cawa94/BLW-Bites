//
//  ShortRecipeCollectionViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 17/5/23.
//

import Foundation

struct ShortRecipeCollectionViewModel {

    let shortRecipe: ShortRecipe
    let inHomepage: Bool

    init(shortRecipe: ShortRecipe, inHomepage: Bool = false) {
        self.shortRecipe = shortRecipe
        self.inHomepage = inHomepage
    }

}
