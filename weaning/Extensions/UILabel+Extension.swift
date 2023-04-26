//
//  UILabel+Extension.swift
//  weaning
//
//  Created by Yuri Cavallin on 26/4/23.
//

import UIKit

extension UILabel {

    @IBInspectable var localizedText: String? {
        get { text }
        set(value) { text = value?.localized() }
    }

}
