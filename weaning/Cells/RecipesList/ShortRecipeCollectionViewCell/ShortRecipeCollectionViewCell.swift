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

    static let defaultHeight: CGFloat = 250

    func configureWith(_ shortRecipe: ShortRecipe) {
        self.nameLabel.text = shortRecipe.name
        self.startingFromLabel.text = shortRecipe.startingFrom

        guard let image = shortRecipe.image
            else { return }
        let reference = StorageService.shared.getReferenceFor(path: image)
        foodImageView.sd_setImage(with: reference, placeholderImage: nil)
        foodImageView.roundCornersSimplified(cornerRadius: foodImageView.frame.height/2, borderWidth: 4, borderColor: .white)
    }

}
