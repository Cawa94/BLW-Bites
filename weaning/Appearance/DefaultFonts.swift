//
//  DefaultFonts.swift
//  weaning
//
//  Created by Yuri Cavallin on 18/2/23.
//

import UIKit

extension UIFont {

    static func regularFontOf(size: CGFloat) -> UIFont {
        return fontWith(name: "Alata-Regular", size: size)
    }

    static func titleFontOf(size: CGFloat) -> UIFont {
        return fontWith(name: "Nunito-Bold", size: size)
    }

    static func boldFontOf(size: CGFloat) -> UIFont {
        return fontWith(name: "Nunito-ExtraBold", size: size)
    }

    private static func fontWith(name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size)
            .unwrap(failureDescription: "Can't load font with name: \(name). Check bundle and .plist file.")
    }

}
