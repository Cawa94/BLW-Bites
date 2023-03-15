//
//  MenuViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/3/23.
//

import Foundation

struct MenuViewModel {

    let menuId: String
    var menuDays: [MenuDay]?
    var selectedRow: Int

    init(menuId: String) {
        self.menuId = menuId
        self.menuDays = []
        self.selectedRow = 0
    }

}
