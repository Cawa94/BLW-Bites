//
//  MenuDish.swift
//  weaning
//
//  Created by Yuri Cavallin on 15/3/23.
//

import Foundation

public struct MenuDish: Codable {

    let id: String?
    let isFood: Bool?
    let name: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id
        case isFood = "is_food"
        case name
        case image
    }

    init(data: [String: Any]) {
        self.id = data["id"] as? String
        self.isFood = data["is_food"] as? Bool ?? false
        self.name = data["name"] as? String
        self.image = data["image"] as? String
    }

}
