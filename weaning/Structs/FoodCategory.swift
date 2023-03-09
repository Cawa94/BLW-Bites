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
        .init(id: "fruit", name: "Fruit", imageName: "fruit"),
        .init(id: "vegetable", name: "Vegetable", imageName: "vegetable"),
        .init(id: "meat", name: "Meat", imageName: "meat"),
        .init(id: "fish", name: "Fish", imageName: "fish"),
    ]

}
