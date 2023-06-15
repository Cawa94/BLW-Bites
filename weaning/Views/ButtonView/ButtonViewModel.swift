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
    let tapHandler: TapHandler

    init(title: String,
         tapHandler: @escaping TapHandler) {
        self.title = title
        self.tapHandler = tapHandler
    }

}
