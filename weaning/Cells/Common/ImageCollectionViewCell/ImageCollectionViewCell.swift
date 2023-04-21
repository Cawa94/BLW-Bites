//
//  ImageCollectionViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 25/2/23.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var foodImageView: UIImageView!

    func configureWith(_ image: String) {
        if !image.isEmpty {
            let reference = StorageService.shared.getReferenceFor(path: image)
            foodImageView.sd_setImage(with: reference, placeholderImage: nil)
            foodImageView.roundCornersSimplified()
        }

        drawShadow()
        layoutIfNeeded()
    }

}
