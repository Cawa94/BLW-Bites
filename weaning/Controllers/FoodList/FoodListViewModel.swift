//
//  FoodListViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import FirebaseCore
import FirebaseFirestore

struct FoodListViewModel {

    var foods: [Food]
    var categorySelected: Int?

    init() {
        foods = []
    }

}
