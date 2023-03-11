//
//  MenuViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/3/23.
//

import Foundation

struct MenuViewModel {

    let menuId: String
    var recipe: Recipe?
    var selectedRow: Int

    init(menuId: String) {
        self.menuId = menuId
        self.selectedRow = 0
    }

}
