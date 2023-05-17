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
         cellFavoriteImageView: UIImageView?) {
        self.foodId = foodId
        self.cellFavoriteImageView = cellFavoriteImageView
    }

}
