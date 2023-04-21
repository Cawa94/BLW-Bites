//
//  Food.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import Foundation

public struct Food: Codable {

    let id: String?
    let name: String?
    let image: String?
    let description: String?
    let category: String?
    let startingFrom: String?
    let riskChoking: Bool?
    let allergenic: Bool?
    let ageDictionary: AgeDictionary?
    let infosDictionary: FoodInfosDictionary?
    let recipes: [ShortRecipe]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case description
        case category
        case startingFrom = "starting_from"
        case riskChoking = "risk_choking"
        case allergenic
        case ageDictionary = "age_dictionary"
        case infosDictionary = "infos_dictionary"
        case recipes
    }

    init(data: [String: Any]) {
        self.id = data["id"] as? String
        self.name = data["name"] as? String
        self.image = data["image"] as? String
        self.description = data["description"] as? String
        self.category = data["category"] as? String
        self.startingFrom = data["starting_from"] as? String
        self.riskChoking = data["risk_choking"] as? Bool
        self.allergenic = data["allergenic"] as? Bool
        self.ageDictionary = data["age_dictionary"] as? AgeDictionary
        self.infosDictionary = data["infos_dictionary"] as? FoodInfosDictionary
        self.recipes = data["recipes"] as? [ShortRecipe]
    }

}

extension Food {

    var hasAgeDictionary: Bool {
        ageDictionary != nil
    }

    var hasInfosDictionary: Bool {
        infosDictionary != nil
    }

    var hasRecipes: Bool {
        !(recipes?.isEmpty ?? true)
    }

    var hasDescription: Bool {
        !(description?.isEmpty ?? true)
    }

    var categoryImage: String {
        FoodCategory.allValues.first(where: { $0.id == category ?? "" })?.imageName ?? ""
    }

    var ageSegments: [AgeSegment] {
        var segments: [AgeSegment] = []
        if let first = ageDictionary?.first {
            segments.append(first)
        }
        if let second = ageDictionary?.second {
            segments.append(second)
        }
        if let third = ageDictionary?.third {
            segments.append(third)
        }
        if let fourth = ageDictionary?.fourth {
            segments.append(fourth)
        }
        return segments
    }

    var infoSections: [InfoSection] {
        var infos: [InfoSection] = []
        if let first = infosDictionary?.first {
            infos.append(first)
        }
        if let second = infosDictionary?.second {
            infos.append(second)
        }
        if let third = infosDictionary?.third {
            infos.append(third)
        }
        if let fourth = infosDictionary?.fourth {
            infos.append(fourth)
        }
        if let fifth = infosDictionary?.fifth {
            infos.append(fifth)
        }
        if let sixth = infosDictionary?.sixth {
            infos.append(sixth)
        }
        if let seventh = infosDictionary?.seventh {
            infos.append(seventh)
        }
        return infos
    }

}
