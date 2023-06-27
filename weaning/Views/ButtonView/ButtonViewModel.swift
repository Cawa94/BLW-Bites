//
//  ButtonViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 14/6/23.
//

import Foundation
import StoreKit

struct ButtonViewModel {

    typealias TapHandler = () -> Void

    let title: String
    let fontSize: CGFloat
    let tapHandler: TapHandler

    init(title: String,
         fontSize: CGFloat = 18,
         tapHandler: @escaping TapHandler) {
        self.title = title
        self.fontSize = fontSize
        self.tapHandler = tapHandler
    }

}
