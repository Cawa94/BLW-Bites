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
    let backgroundColor: UIColor
    let icon: UIImage?
    let tapHandler: TapHandler

    init(title: String,
         fontSize: CGFloat = 18,
         backgroundColor: UIColor = .mainColor,
         icon: UIImage? = nil,
         tapHandler: @escaping TapHandler) {
        self.title = title
        self.fontSize = fontSize
        self.backgroundColor = backgroundColor
        self.icon = icon
        self.tapHandler = tapHandler
    }

}
