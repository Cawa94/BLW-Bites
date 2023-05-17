//
//  UserDefaults.swift
//  weaning
//
//  Created by Yuri Cavallin on 17/5/23.
//

import UIKit

struct DefaultsKeys {
    static let favoriteFoodsKey = "favorite_foods"
    static let favoriteRecipessKey = "favorite_recipes"
}

struct UserDefaultsService {

    static var favoriteFoods: [String] {
        let defaults = UserDefaults.standard
        if let favoriteFoodsArray = defaults.object(forKey: DefaultsKeys.favoriteFoodsKey) as? [String] {
            return favoriteFoodsArray
        } else {
            return []
        }
    }

    static var favoriteRecipes: [String] {
        let defaults = UserDefaults.standard
        if let favoriteRecipesArray = defaults.object(forKey: DefaultsKeys.favoriteRecipessKey) as? [String] {
            return favoriteRecipesArray
        } else {
            return []
        }
    }

    static func addFoodToFavorite(_ foodId: String) {
        let defaults = UserDefaults.standard
        var foods = favoriteFoods
        foods.append(foodId)
        defaults.set(foods, forKey: DefaultsKeys.favoriteFoodsKey)
    }

    static func addRecipeToFavorite(_ recipeId: String) {
        let defaults = UserDefaults.standard
        var recipes = favoriteRecipes
        recipes.append(recipeId)
        defaults.set(recipes, forKey: DefaultsKeys.favoriteRecipessKey)
    }

    static func removeFoodFromFavorite(_ foodId: String) {
        let defaults = UserDefaults.standard
        var foods = favoriteFoods
        foods.removeAll(where: { $0 == foodId })
        defaults.set(foods, forKey: DefaultsKeys.favoriteFoodsKey)
    }

    static func removeRecipeFromFavorite(_ recipeId: String) {
        let defaults = UserDefaults.standard
        var recipes = favoriteRecipes
        recipes.removeAll(where: { $0 == recipeId })
        defaults.set(recipes, forKey: DefaultsKeys.favoriteRecipessKey)
    }

}
