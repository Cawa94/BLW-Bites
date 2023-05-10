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
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var foodImageView: UIImageView!
    @IBOutlet private weak var startingFromLabel: UILabel!
    @IBOutlet private weak var premiumImageView: UIImageView!
    @IBOutlet private weak var unavailableView: UIView!
    @IBOutlet private weak var newView: UIView!
    @IBOutlet private weak var seasonalView: UIView!

    static let defaultHeight: CGFloat = 230

    public var publicImageView: UIImageView {
        foodImageView
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        foodImageView.image = nil
        unavailableView.isHidden = true
        newView.isHidden = true
        seasonalView.isHidden = true
    }

    func configureWith(_ shortFood: ShortFood, imageCornerRadius: CGFloat) {
        nameLabel.text = shortFood.name
        startingFromLabel.text = shortFood.startingFrom
        premiumImageView.isHidden = shortFood.isFree || PurchaseManager.shared.hasUnlockedPro
        imageContainerView.roundCornersSimplified(cornerRadius: imageCornerRadius, borderWidth: 1.5, borderColor: .mainColor)
        unavailableView.roundCornersSimplified(cornerRadius: imageCornerRadius, borderWidth: 4, borderColor: .white)
        newView.roundCornersSimplified(cornerRadius: newView.frame.height/2, borderWidth: 1, borderColor: .white)
        newView.isHidden = !shortFood.isNew
        seasonalView.isHidden = !shortFood.isSeasonal

        if !(shortFood.isFree) && !PurchaseManager.shared.hasUnlockedPro {
            self.unavailableView.isHidden = false
        }

        guard let image = shortFood.image, !image.isEmpty
            else { return }
        let reference = StorageService.shared.getReferenceFor(path: image)
        foodImageView.sd_setImage(with: reference, placeholderImage: nil)
    }

}
