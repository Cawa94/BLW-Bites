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

    static let defaultHeight: CGFloat = 230

    func configureWith(_ shortFood: ShortFood) {
        nameLabel.text = shortFood.name
        startingFromLabel.text = shortFood.startingFrom

        foodImageView.roundCornersSimplified(cornerRadius: foodImageView.frame.height/2, borderWidth: 4, borderColor: .white)

        guard let image = shortFood.image
            else { return }
        let reference = StorageService.shared.getReferenceFor(path: image)
        foodImageView.sd_setImage(with: reference, placeholderImage: nil)
    }

}
