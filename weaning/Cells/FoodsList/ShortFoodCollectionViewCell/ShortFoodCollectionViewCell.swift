//
//  ShortFoodCollectionViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import UIKit
import FirebaseStorageUI

class ShortFoodCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var foodImageView: UIImageView!
    @IBOutlet private weak var startingFromLabel: UILabel!
    @IBOutlet private weak var startingFromBackground: UIView!
    @IBOutlet private weak var startingFromWidthConstraint: NSLayoutConstraint!

    static let defaultHeight: CGFloat = 180

    func configureWith(_ shortFood: ShortFood) {
        nameLabel.text = shortFood.name
        startingFromLabel.text = shortFood.startingFrom
        let labelWidth = startingFromLabel.intrinsicContentSize.width + 12
        startingFromWidthConstraint.constant = labelWidth
        layoutIfNeeded()

        guard let image = shortFood.image
            else { return }
        let reference = StorageService.shared.getReferenceFor(path: image)
        foodImageView.sd_setImage(with: reference, placeholderImage: nil)
        startingFromBackground.roundCorners(corners: [.topRight, .bottomRight],
                                            cornerRadius: .smallCornerRadius)
    }

}
