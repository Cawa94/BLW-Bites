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
    let firstSnack: MenuMeal?
    let secondSnack: MenuMeal?
    let dayPicture: String?

    enum CodingKeys: String, CodingKey {
        case anytime
        case breakfast
        case lunch
        case dinner
        case firstSnack = "first_snack"
        case secondSnack = "second_snack"
        case dayPicture = "day_picture"
    }

    init(data: [String: Any]) {
        self.anytime = data["anytime"] != nil ? MenuMeal(data: data["anytime"] as? [String : Any] ?? [:]) : nil
        self.breakfast = data["breakfast"] != nil ? MenuMeal(data: data["breakfast"] as? [String : Any] ?? [:]) : nil
        self.lunch = data["lunch"] != nil ? MenuMeal(data: data["lunch"] as? [String : Any] ?? [:]) : nil
        self.dinner = data["dinner"] != nil ? MenuMeal(data: data["dinner"] as? [String : Any] ?? [:]) : nil
        self.firstSnack = data["first_snack"] != nil ? MenuMeal(data: data["first_snack"] as? [String : Any] ?? [:]) : nil
        self.secondSnack = data["second_snack"] != nil ? MenuMeal(data: data["second_snack"] as? [String : Any] ?? [:]) : nil
        self.dayPicture = data["day_picture"] as? String
    }

}

extension MenuDay {

    var meals: [MenuMeal] {
        var tempMeals: [MenuMeal] = []
        if let anytime = anytime {
            tempMeals.append(anytime.copyWith(category: "MENU_ANYTIME".localized()))
        }
        if let breakfast = breakfast {
            tempMeals.append(breakfast.copyWith(category: "MENU_BREAKFAST".localized()))
        }
        if let firstSnack = firstSnack {
            tempMeals.append(firstSnack.copyWith(category: "MENU_FIRST_SNACK".localized()))
        }
        if let lunch = lunch {
            tempMeals.append(lunch.copyWith(category: "MENU_LUNCH".localized()))
        }
        if let secondSnack = secondSnack {
            tempMeals.append(secondSnack.copyWith(category: "MENU_SECOND_SNACK".localized()))
        }
        if let dinner = dinner {
            tempMeals.append(dinner.copyWith(category: "MENU_DINNER".localized()))
        }
        return tempMeals
    }

    var mealsCount: Int {
        meals.count
    }

}
