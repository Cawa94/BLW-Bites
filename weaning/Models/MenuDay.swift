//
//  MenuDay.swift
//  weaning
//
//  Created by Yuri Cavallin on 15/3/23.
//

import Foundation

public struct MenuDay: Codable {

    let anytime: MenuMeal?
    let breakfast: MenuMeal?
    let lunch: MenuMeal?
    let dinner: MenuMeal?

    enum CodingKeys: String, CodingKey {
        case anytime
        case breakfast
        case lunch
        case dinner
    }

    init(data: [String: Any]) {
        self.anytime = data["anytime"] != nil ? MenuMeal(data: data["anytime"] as? [String : Any] ?? [:]) : nil
        self.breakfast = data["breakfast"] != nil ? MenuMeal(data: data["breakfast"] as? [String : Any] ?? [:]) : nil
        self.lunch = data["lunch"] != nil ? MenuMeal(data: data["lunch"] as? [String : Any] ?? [:]) : nil
        self.dinner = data["dinner"] != nil ? MenuMeal(data: data["dinner"] as? [String : Any] ?? [:]) : nil
    }

}

extension MenuDay {

    var meals: [MenuMeal] {
        var tempMeals: [MenuMeal] = []
        if let anytime = anytime {
            tempMeals.append(anytime)
        }
        if let breakfast = breakfast {
            tempMeals.append(breakfast)
        }
        if let lunch = lunch {
            tempMeals.append(lunch)
        }
        if let dinner = dinner {
            tempMeals.append(dinner)
        }
        return tempMeals
    }

    var mealsCount: Int {
        meals.count
    }

}
