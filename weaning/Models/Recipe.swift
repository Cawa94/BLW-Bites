//
//  Recipes.swift
//  weaning
//
//  Created by Yuri Cavallin on 28/2/23.
//

import Foundation

public struct Recipe: Codable {

    let id: String?
    let name: String?
    let image: String?
    let description: String?
    let category: [String]?
    let startingFrom: String?
    let ingredients: [String]?
    let steps: [String]?
    let tips: String?
    let foods: [ShortFood]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case description
        case category
        case startingFrom = "starting_from"
        case ingredients
        case steps
        case tips
        case foods
    }

    init(data: [String: Any]) {
        self.id = data["id"] as? String
        self.name = data["name"] as? String
        self.image = data["image"] as? String
        self.description = data["description"] as? String
        self.category = data["category"] as? [String]
        self.startingFrom = data["starting_from"] as? String
        self.ingredients = data["ingredients"] as? [String]
        self.steps = data["steps_dictionary"] as? [String]
        self.tips = data["tips"] as? String
        self.foods = data["foods"] as? [ShortFood]
    }

}

extension Recipe {

    var hasIngredients: Bool {
        ingredients != nil
    }

    var hasSteps: Bool {
        steps != nil
    }

    var hasTips: Bool {
        tips != nil
    }

    var hasFoods: Bool {
        !(foods?.isEmpty ?? true)
    }

    var ingredientsDescription: String {
        var description = ""
        for ingredient in ingredients ?? [] {
            description += "• \(ingredient)\n"
        }
        description = String(description.dropLast(2))
        return description
    }

    var stepsDescription: String {
        var description = ""
        for step in (steps ?? []).enumerated() {
            description += "\(step.offset + 1). \(step.element)\n"
        }
        description = String(description.dropLast(2))
        return description
    }

}
