//
//  MenuMeal.swift
//  weaning
//
//  Created by Yuri Cavallin on 15/3/23.
//

import Foundation

public struct MenuMeal: Codable {

    let category: String?
    let dishes: [MenuDish]?

    enum CodingKeys: String, CodingKey {
        case category
        case dishes
    }

    init(data: [String: Any]) {
        self.category = data["category"] as? String

        var dishes: [MenuDish] = []
        if let dishesArray = data["dishes"] as? [[String : Any]] {
            for dishDict in dishesArray {
                dishes.append(.init(data: dishDict))
            }
        }
        self.dishes = dishes
    }

}
