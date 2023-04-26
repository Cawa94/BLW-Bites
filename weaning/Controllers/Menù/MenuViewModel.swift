//
//  MenuViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/3/23.
//

import Foundation

struct MenuViewModel {

    let menuId: String
    let menuName: String
    var menuDays: [MenuDay]?
    var selectedRow: Int

    init(menuId: String, menuName: String) {
        self.menuId = menuId
        self.menuName = menuName
        self.menuDays = []
        self.selectedRow = 0
    }

}
