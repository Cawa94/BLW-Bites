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
    @IBOutlet private weak var premiumImageView: UIImageView!

    var testPictures: [String] =
    [
        "gs://app-svezzamento.appspot.com/recipes/chicken_burgers/stock-photo-fast-food-delicious-chicken-hamburger-2289673301.jpg",
        "gs://app-svezzamento.appspot.com/recipes/couscous_and_avocado_balls/stock-photo-healthy-salad-with-couscous-sun-dried-tomato-avocado-arugula-and-parmesan-cheese-610319780.jpg",
        "gs://app-svezzamento.appspot.com/recipes/hummus_made_from_chickpeas/stock-photo-classic-hummus-with-parsley-on-the-plate-and-pita-bread-horizontal-top-view-282976058.jpg",
        "gs://app-svezzamento.appspot.com/recipes/oatmeal_with_pumpkin_and_cinnamon/stock-photo-healthy-inside-healthy-natural-nutritious-being-in-the-plate-and-preparing-for-being-taking-1040799652.jpg",
        "gs://app-svezzamento.appspot.com/recipes/pasta_with_carrot_pesto/stock-photo-pasta-spaghetti-with-pesto-sauce-and-fresh-basil-leaves-in-grey-bowl-light-grey-background-top-1969988881.jpg"
    ]

    static let defaultHeight: CGFloat = 250

    override func prepareForReuse() {
        super.prepareForReuse()

        foodImageView.image = nil
    }

    func configureWith(_ shortRecipe: ShortRecipe, imageCornerRadius: CGFloat) {
        nameLabel.text = shortRecipe.name
        startingFromLabel.text = shortRecipe.startingFrom
        premiumImageView.isHidden = shortRecipe.isFree ?? false || PurchaseManager.shared.hasUnlockedPro
        foodImageView.roundCornersSimplified(cornerRadius: imageCornerRadius, borderWidth: 4, borderColor: .white)

        guard let image = shortRecipe.image, !image.isEmpty
            // else { return }
            else {
                // FOR TESTING ONLY
                let reference = StorageService.shared.getReferenceFor(path: testPictures.randomElement() ?? "")
                foodImageView.sd_setImage(with: reference, placeholderImage: nil, completion: { image, error, type, url in
                    if !(shortRecipe.isFree ?? false) && !PurchaseManager.shared.hasUnlockedPro {
                        self.foodImageView.image = image?.grayscaled
                    }
                })
                return
            }
        let reference = StorageService.shared.getReferenceFor(path: image)
        foodImageView.sd_setImage(with: reference, placeholderImage: nil, completion: { image, error, type, url in
            if !(shortRecipe.isFree ?? false) && !PurchaseManager.shared.hasUnlockedPro {
                self.foodImageView.image = image?.grayscaled
            }
        })
    }

}
