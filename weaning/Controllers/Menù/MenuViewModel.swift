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
    let is30Days: Bool

    init(menuId: String, menuName: String, is30Days: Bool = false) {
        self.menuId = menuId
        self.menuName = menuName
        self.menuDays = []
        self.selectedRow = 0
        self.is30Days = is30Days
    }

}
