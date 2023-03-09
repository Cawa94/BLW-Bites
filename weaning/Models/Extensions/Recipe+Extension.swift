//
//  Recipe+Extension.swift
//  weaning
//
//  Created by Yuri Cavallin on 1/3/23.
//

import Foundation

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
