//
//  ShortFoodCollectionViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 17/5/23.
//

import Foundation

struct ShortFoodCollectionViewModel {

    let shortFood: ShortFood
    let food: Food?
    let inHomepage: Bool

    init(shortFood: ShortFood, food: Food?, inHomepage: Bool = false) {
        self.shortFood = shortFood
        self.food = food
        self.inHomepage = inHomepage
    }

}
