//
//  ShortFoodCollectionViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 17/5/23.
//

import Foundation

struct ShortFoodCollectionViewModel {

    let shortFood: ShortFood
    let inHomepage: Bool

    init(shortFood: ShortFood, inHomepage: Bool = false) {
        self.shortFood = shortFood
        self.inHomepage = inHomepage
    }

}
