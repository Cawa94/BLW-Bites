//
//  MenuDishViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 15/3/23.
//

import Foundation

struct MenuDishViewModel {

    typealias TapHandler = () -> Void

    let menuDish: MenuDish
    let hideSeparator: Bool
    let tapHandler: TapHandler

    init(menuDish: MenuDish,
         hideSeparator: Bool = false,
         tapHandler: @escaping TapHandler) {
        self.menuDish = menuDish
        self.hideSeparator = hideSeparator
        self.tapHandler = tapHandler
    }

}
