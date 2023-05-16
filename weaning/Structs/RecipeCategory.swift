//
//  RecipeCategory.swift
//  weaning
//
//  Created by Yuri Cavallin on 28/2/23.
//

import Foundation

struct RecipeCategory {

    let id: String
    let name: String
    let imageName: String

    static let allValues: [RecipeCategory] = [
        // .init(id: "favorites", name: "GLOBAL_FAVORITES".localized(), imageName: "heart_full"),
        .init(id: "breakfast", name: "RECIPE_CATEGORY_BREAKFAST".localized(), imageName: "breakfast"),
        .init(id: "lunch", name: "RECIPE_CATEGORY_LUNCH".localized(), imageName: "lunch"),
        .init(id: "snack", name: "RECIPE_CATEGORY_SNACK".localized(), imageName: "snack"),
        .init(id: "dinner", name: "RECIPE_CATEGORY_DINNER".localized(), imageName: "dinner"),
    ]

}
