//
//  HomepageViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 18/2/23.
//

struct HomepageViewModel {

    var homepageFoods: [Food]
    var homepageRecipes: [Recipe]

    init() {
        homepageFoods = []
        homepageRecipes = []
    }

    var freeFoods: [Food] {
        homepageFoods.filter { $0.isFree }
    }

    var freeRecipes: [Recipe] {
        homepageRecipes.filter { $0.isFree }
    }

    var seasonalFoods: [Food] {
        homepageFoods.filter { $0.isSeasonal }
    }
    
    var seasonalRecipes: [Recipe] {
        homepageRecipes.filter { $0.isSeasonal }
    }
    
    var newFoods: [Food] {
        homepageFoods.filter { $0.isNew }
    }

    var newRecipes: [Recipe] {
        homepageRecipes.filter { $0.isNew }
    }

}
