//
//  UICollectionView+Extension.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import UIKit

extension UICollectionViewCell {

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    func drawCellShadow(cornerRadius: CGFloat = .defaultCornerRadius) {
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: contentView.layer.cornerRadius).cgPath
    }

}
