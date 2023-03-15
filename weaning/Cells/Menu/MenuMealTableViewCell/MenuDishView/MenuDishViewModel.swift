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
    let tapHandler: TapHandler

    init(menuDish: MenuDish,
         tapHandler: @escaping TapHandler) {
        self.menuDish = menuDish
        self.tapHandler = tapHandler
    }

}
