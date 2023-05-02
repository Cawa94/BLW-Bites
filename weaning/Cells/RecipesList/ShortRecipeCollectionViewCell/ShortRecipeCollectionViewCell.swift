//
//  ShortRecipeCollectionViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 1/3/23.
//

import UIKit

class ShortRecipeCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var foodImageView: UIImageView!
    @IBOutlet private weak var startingFromLabel: UILabel!
    @IBOutlet private weak var premiumImageView: UIImageView!
    @IBOutlet private weak var unavailableView: UIView!
    @IBOutlet private weak var newView: UIView!
    @IBOutlet private weak var seasonalView: UIView!

    static let defaultHeight: CGFloat = 250

    override func prepareForReuse() {
        super.prepareForReuse()

        foodImageView.image = UIImage(named: "recipe_placeholder")
        unavailableView.isHidden = true
        newView.isHidden = true
        seasonalView.isHidden = true
    }

    func configureWith(_ shortRecipe: ShortRecipe, imageCornerRadius: CGFloat) {
        nameLabel.text = shortRecipe.name
        startingFromLabel.text = shortRecipe.startingFrom
        premiumImageView.isHidden = shortRecipe.isFree || PurchaseManager.shared.hasUnlockedPro
        imageContainerView.roundCornersSimplified(cornerRadius: imageCornerRadius, borderWidth: 4, borderColor: .white)
        unavailableView.roundCornersSimplified(cornerRadius: imageCornerRadius, borderWidth: 4, borderColor: .white)
        newView.roundCornersSimplified(cornerRadius: newView.frame.height/2, borderWidth: 1, borderColor: .white)
        newView.isHidden = !shortRecipe.isNew
        seasonalView.isHidden = !shortRecipe.isSeasonal

        if !(shortRecipe.isFree) && !PurchaseManager.shared.hasUnlockedPro {
            self.unavailableView.isHidden = false
        }

        guard let image = shortRecipe.image, !image.isEmpty
            else { return }
        let reference = StorageService.shared.getReferenceFor(path: image)
        foodImageView.sd_setImage(with: reference, placeholderImage: nil)
    }

}
