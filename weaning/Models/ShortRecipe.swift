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
    let properties: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case category
        case startingFrom = "starting_from"
        case properties
    }

    init(data: [String: Any]) {
        self.id = data["id"] as? String
        self.name = data["name"] as? String
        self.image = data["image"] as? String
        self.category = data["category"] as? [String]
        self.startingFrom = data["starting_from"] as? String
        self.properties = data["properties"] as? [String]
    }

    init(id: String?,
         name: String?,
         image: String?,
         category: [String]?,
         startingFrom: String?,
         properties: [String]?) {
        self.id = id
        self.name = name
        self.image = image
        self.category = category
        self.startingFrom = startingFrom
        self.properties = properties
    }

}

extension ShortRecipe {

    var isFree: Bool {
        properties?.contains(where: { $0 == "free" }) ?? false
    }

    var isNew: Bool {
        properties?.contains(where: { $0 == "new" }) ?? false
    }

    var isSeasonal: Bool {
        properties?.contains(where: { $0 == "seasonal" }) ?? false
    }

    var isFavorite: Bool {
        UserDefaultsService.favoriteRecipes.contains(where: { $0 == id })
    }

}
