//
//  MenuViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/3/23.
//

import Foundation

struct MenuViewModel {

    let menuDaysPictures = [
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_00.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_01.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_02.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_03.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_04.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_05.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_06.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_07.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_08.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_09.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_10.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_02.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_00.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_01.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_02.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_00.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_01.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_02.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_00.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_01.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_02.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_00.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_01.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_02.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_00.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_01.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_02.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_00.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_01.JPG",
        "gs://app-svezzamento.appspot.com/menus/30_days_spring_summer/menu_02.JPG"
    ]

    let menuId: String
    let menuName: String
    var menuDay: MenuDay?
    var selectedRow: Int
    let is30Days: Bool

    init(menuId: String, menuName: String, is30Days: Bool = false) {
        self.menuId = menuId
        self.menuName = menuName
        self.selectedRow = 0
        self.is30Days = is30Days
    }

}
