//
//  UITextView+Extension.swift
//  weaning
//
//  Created by Yuri Cavallin on 26/4/23.
//

import UIKit

extension UITextView {

    @IBInspectable var localizedText: String? {
        get { text }
        set(value) { text = value?.localized() }
    }

}
