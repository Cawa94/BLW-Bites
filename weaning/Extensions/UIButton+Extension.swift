//
//  UIButton+Extension.swift
//  weaning
//
//  Created by Yuri Cavallin on 21/6/23.
//

import UIKit

extension UIButton {

    @IBInspectable var localizedText: String? {
        get { titleLabel?.text }
        set(value) {
            var attributes = AttributeContainer()
            attributes.font = .boldFontOf(size: self.titleLabel?.font.pointSize ?? 20)

            let title = AttributedString(value?.localized() ?? "", attributes: attributes)
            self.configuration?.attributedTitle = title
        }
    }

    func setAttributedTitle(_ value: String) {
        var attributes = AttributeContainer()
        attributes.font = .boldFontOf(size: self.titleLabel?.font.pointSize ?? 20)

        let title = AttributedString(value, attributes: attributes)
        self.configuration?.attributedTitle = title
    }

}
