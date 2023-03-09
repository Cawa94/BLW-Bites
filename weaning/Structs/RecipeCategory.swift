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
        .init(id: "breakfast", name: "Breakfast", imageName: "breakfast"),
        .init(id: "lunch", name: "Lunch", imageName: "lunch"),
        .init(id: "snack", name: "Snack", imageName: "snack"),
        .init(id: "dinner", name: "Dinner", imageName: "dinner"),
    ]

}
