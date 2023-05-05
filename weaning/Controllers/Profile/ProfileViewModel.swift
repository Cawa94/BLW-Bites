//
//  ProfileViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 5/5/23.
//

import Foundation

struct ProfileViewModel {
    
    var homepageFoods: [ShortFood]
    var homepageRecipes: [ShortRecipe]
    
    init() {
        homepageFoods = []
        homepageRecipes = []
    }
    
}
