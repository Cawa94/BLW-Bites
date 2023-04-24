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
    @IBOutlet private weak var premiumImageView: UIImageView!

    var testPictures: [String] =
    [
        "gs://app-svezzamento.appspot.com/foods/pineapple/IMG_9099.JPG",
        "gs://app-svezzamento.appspot.com/foods/apple/IMG_8871.JPG",
        "gs://app-svezzamento.appspot.com/foods/pasta/IMG_0142.JPG",
        "gs://app-svezzamento.appspot.com/foods/passion_fruit/IMG_8969.JPG",
        "gs://app-svezzamento.appspot.com/foods/pumpkin/IMG_9855.JPG",
        "gs://app-svezzamento.appspot.com/foods/kiwi/IMG_8791.JPG",
        "gs://app-svezzamento.appspot.com/foods/cauliflower/IMG_9111.JPG",
        "gs://app-svezzamento.appspot.com/foods/carrot/IMG_9114.JPG",
        "gs://app-svezzamento.appspot.com/foods/broccoli/IMG_9115.JPG",
        "gs://app-svezzamento.appspot.com/foods/bell_pepper/IMG_9792.JPG",
        "gs://app-svezzamento.appspot.com/foods/blackberries/IMG_8918.JPG",
        "gs://app-svezzamento.appspot.com/foods/asparagus/IMG_9818.JPG",
        "gs://app-svezzamento.appspot.com/foods/avocado/IMG_8962.JPG"
    ]

    static let defaultHeight: CGFloat = 250

    override func awakeFromNib() {
        super.awakeFromNib()

        foodImageView.roundCornersSimplified(cornerRadius: foodImageView.frame.height/2, borderWidth: 4, borderColor: .white)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        foodImageView.image = nil
    }

    func configureWith(_ shortFood: ShortFood) {
        nameLabel.text = shortFood.name
        startingFromLabel.text = shortFood.startingFrom
        premiumImageView.isHidden = shortFood.isFree ?? false || PurchaseManager.shared.hasUnlockedPro

        guard let image = shortFood.image, !image.isEmpty
            // else { return }
            else {
                // FOR TESTING ONLY
                let reference = StorageService.shared.getReferenceFor(path: testPictures.randomElement() ?? "")
                foodImageView.sd_setImage(with: reference, placeholderImage: nil, completion: { image, error, type, url in
                    if !(shortFood.isFree ?? false) && !PurchaseManager.shared.hasUnlockedPro {
                        self.foodImageView.image = image?.grayscaled
                    }
                })
                return
            }
        let reference = StorageService.shared.getReferenceFor(path: image)
        foodImageView.sd_setImage(with: reference, placeholderImage: nil, completion: { image, error, type, url in
            if !(shortFood.isFree ?? false) && !PurchaseManager.shared.hasUnlockedPro {
                self.foodImageView.image = image?.grayscaled
            }
        })
    }

}
