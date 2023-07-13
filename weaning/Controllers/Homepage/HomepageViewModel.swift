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
        homepageFoods.filter { $0.isFree && !($0.isHidden ?? false) }
    }

    var freeRecipes: [Recipe] {
        homepageRecipes.filter { $0.isFree && !($0.isHidden ?? false) }
    }

    var seasonalFoods: [Food] {
        homepageFoods.filter { $0.isSeasonal && !($0.isHidden ?? false) }
    }
    
    var seasonalRecipes: [Recipe] {
        homepageRecipes.filter { $0.isSeasonal && !($0.isHidden ?? false) }
    }
    
    var newFoods: [Food] {
        homepageFoods.filter { $0.isNew && !($0.isHidden ?? false) }
    }

    var newRecipes: [Recipe] {
        homepageRecipes.filter { $0.isNew && !($0.isHidden ?? false) }
    }

}
