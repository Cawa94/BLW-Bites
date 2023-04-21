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
        .init(id: "fruit", name: "Owoce", imageName: "fruit"),
        .init(id: "vegetable", name: "Warzywa", imageName: "vegetable"),
        .init(id: "meat", name: "Mięso", imageName: "meat"),
        .init(id: "fish", name: "Fish", imageName: "fish"),
        .init(id: "cereals", name: "Ryby", imageName: ""),
        .init(id: "cheese", name: "Ser", imageName: ""),
        .init(id: "seeds", name: "Nasiona", imageName: ""),
        .init(id: "legumes", name: "Jarzyny strączkowe", imageName: ""),
        .init(id: "egg", name: "Jajko", imageName: ""),
        .init(id: "sugar", name: "Cukier", imageName: ""),
        .init(id: "avoid", name: "Unikać", imageName: "")
    ]

}
