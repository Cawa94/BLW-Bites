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

    override func prepareForReuse() {
        super.prepareForReuse()

        foodImageView.image = nil
    }

    func configureWith(_ shortRecipe: ShortRecipe) {
        nameLabel.text = shortRecipe.name
        startingFromLabel.text = shortRecipe.startingFrom
        foodImageView.roundCornersSimplified(cornerRadius: foodImageView.frame.height/2, borderWidth: 4, borderColor: .white)

        guard let image = shortRecipe.image, !image.isEmpty
            else { return }
        let reference = StorageService.shared.getReferenceFor(path: image)
        foodImageView.sd_setImage(with: reference, placeholderImage: nil)
    }

}
