//
//  MenuSelectorViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/3/23.
//

import Foundation

struct MenuSelectorTableViewModel {

    typealias TapHandler = () -> Void

    let image: String
    let title: String
    let subtitle: String
    let tapHandler: TapHandler

    init(image: String,
         title: String,
         subtitle: String,
         tapHandler: @escaping TapHandler) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.tapHandler = tapHandler
    }

}
