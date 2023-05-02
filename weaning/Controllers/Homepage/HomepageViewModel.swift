//
//  HomepageViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 18/2/23.
//

struct HomepageViewModel {

    var homepageFoods: [ShortFood]
    var homepageRecipes: [ShortRecipe]

    init() {
        homepageFoods = []
        homepageRecipes = []
    }

    var freeFoods: [ShortFood] {
        homepageFoods.filter { $0.isFree }
    }

    var freeRecipes: [ShortRecipe] {
        homepageRecipes.filter { $0.isFree }
    }

    var seasonalFoods: [ShortFood] {
        homepageFoods.filter { $0.isSeasonal }
    }
    
    var seasonalRecipes: [ShortRecipe] {
        homepageRecipes.filter { $0.isSeasonal }
    }
    
    var newFoods: [ShortFood] {
        homepageFoods.filter { $0.isNew }
    }

    var newRecipes: [ShortRecipe] {
        homepageRecipes.filter { $0.isNew }
    }

}
