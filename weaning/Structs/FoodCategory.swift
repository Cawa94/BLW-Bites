//
//  FoodCategory.swift
//  weaning
//
//  Created by Yuri Cavallin on 18/2/23.
//

import Foundation

struct FoodCategory {

    let id: String
    let name: String
    let imageName: String

    static let allValues: [FoodCategory] = [
        .init(id: "favorites", name: "GLOBAL_FAVORITES".localized(), imageName: "heart_full"),
        .init(id: "fruit", name: "FOOD_CATEGORY_FRUIT".localized(), imageName: "fruit"),
        .init(id: "vegetable", name: "FOOD_CATEGORY_VEGETABLE".localized(), imageName: "vegetable"),
        .init(id: "meat", name: "FOOD_CATEGORY_MEAT".localized(), imageName: "meat"),
        .init(id: "fish", name: "FOOD_CATEGORY_FISH".localized(), imageName: "fish"),
        .init(id: "cereals", name: "FOOD_CATEGORY_CEREALS".localized(), imageName: "cereals"),
        .init(id: "cheese", name: "FOOD_CATEGORY_CHEESE".localized(), imageName: "cheese"),
        .init(id: "seeds", name: "FOOD_CATEGORY_SEEDS".localized(), imageName: "seeds"),
        .init(id: "legumes", name: "FOOD_CATEGORY_LEGUMES".localized(), imageName: "legumes"),
        .init(id: "egg", name: "FOOD_CATEGORY_EGG".localized(), imageName: "egg"),
        .init(id: "sugar", name: "FOOD_CATEGORY_SUGAR".localized(), imageName: "sugar"),
        .init(id: "avoid", name: "FOOD_CATEGORY_AVOID".localized(), imageName: "avoid")
    ]

}
