//
//  ShortRecipe.swift
//  weaning
//
//  Created by Yuri Cavallin on 28/2/23.
//

import Foundation

public struct ShortRecipe: Codable {

    let id: String?
    let name: String?
    let image: String?
    let category: [String]?
    let startingFrom: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case category
        case startingFrom = "starting_from"
    }

    init(data: [String: Any]) {
        self.id = data["id"] as? String
        self.name = data["name"] as? String
        self.image = data["image"] as? String
        self.category = data["category"] as? [String]
        self.startingFrom = data["starting_from"] as? String
    }

}
