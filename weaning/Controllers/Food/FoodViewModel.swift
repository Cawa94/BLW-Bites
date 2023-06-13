//
//  FoodViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import UIKit

struct FoodViewModel {

    let foodId: String
    var food: Food?
    var cellFavoriteImageView: UIImageView?

    init(foodId: String,
         food: Food?,
         cellFavoriteImageView: UIImageView?) {
        self.foodId = foodId
        self.food = food
        self.cellFavoriteImageView = cellFavoriteImageView
    }

}
