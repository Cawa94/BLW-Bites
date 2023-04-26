//
//  DefaultColors.swift
//  weaning
//
//  Created by Yuri Cavallin on 22/3/23.
//

import Foundation

import UIKit

extension UIColor {

    static let backgroundColor1  = UIColor.named("backgroundColor1")

    static let mainColor         = UIColor.named("mainColor")
    static let textColor         = UIColor.named("textColor")
    static let lightTextColor    = UIColor.named("lightTextColor")

    private static func named(_ name: String) -> UIColor {
        return UIColor(named: name) ?? UIColor()
    }

}
