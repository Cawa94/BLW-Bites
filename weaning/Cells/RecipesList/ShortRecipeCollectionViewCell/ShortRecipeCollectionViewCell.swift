//
//  ShortRecipeCollectionViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 1/3/23.
//

import UIKit

class ShortRecipeCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var foodImageView: UIImageView!
    @IBOutlet private weak var startingFromLabel: UILabel!
    @IBOutlet private weak var startingFromBackground: UIView!
    @IBOutlet private weak var startingFromWidthConstraint: NSLayoutConstraint!

    static let defaultHeight: CGFloat = 200

    func configureWith(_ shortRecipe: ShortRecipe) {
        self.nameLabel.text = shortRecipe.name
        self.startingFromLabel.text = shortRecipe.startingFrom
        let labelWidth = startingFromLabel.intrinsicContentSize.width + 12
        startingFromWidthConstraint.constant = labelWidth
        layoutIfNeeded()

        guard let image = shortRecipe.image
            else { return }
        let reference = StorageService.shared.getReferenceFor(path: image)
        foodImageView.sd_setImage(with: reference, placeholderImage: nil)
        startingFromBackground.roundCorners(corners: [.topRight, .bottomRight],
                                            cornerRadius: .smallCornerRadius)
    }

}
