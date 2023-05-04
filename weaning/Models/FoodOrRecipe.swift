//
//  FoodOrRecipe.swift
//  weaning
//
//  Created by Yuri Cavallin on 28/4/23.
//

import Foundation

struct FoodOrRecipe {

    let id: String?
    let name: String?
    let image: String?
    let category: String?
    let startingFrom: String?
    let properties: [String]?
    let isFood: Bool?
    let isFree: Bool?

    static func initFromFood(_ shortFood: ShortFood) -> FoodOrRecipe {
        return .init(id: shortFood.id, name: shortFood.name, image: shortFood.image, category: shortFood.category, startingFrom: shortFood.startingFrom, properties: shortFood.properties, isFood: true, isFree: shortFood.isFree)
    }

    static func initFromRecipe(_ shortRecipe: ShortRecipe) -> FoodOrRecipe {
        return .init(id: shortRecipe.id, name: shortRecipe.name, image: shortRecipe.image, category: nil, startingFrom: shortRecipe.startingFrom, properties: shortRecipe.properties, isFood: false, isFree: shortRecipe.isFree)
    }

    func initFood() -> ShortFood {
        .init(id: id, name: name, image: image, category: category, startingFrom: startingFrom, properties: properties)
    }

    func initRecipe() -> ShortRecipe {
        .init(id: id, name: name, image: image, category: nil, startingFrom: startingFrom, properties: properties)
    }

}
