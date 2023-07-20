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
    @IBOutlet private weak var favoriteImageView: UIImageView!

    static var heightWidthRatio = 1.5
    private var viewModel: ShortRecipeCollectionViewModel?

    public var publicImageView: UIImageView {
        foodImageView
    }

    public var publicFavoriteImageView: UIImageView {
        favoriteImageView
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        unavailableView.isHidden = true
        newView.isHidden = true
        seasonalView.isHidden = true
        favoriteImageView.image = .init(named: "heart_empty")
    }

    func configureWith(_ viewModel: ShortRecipeCollectionViewModel, imageCornerRadius: CGFloat) {
        self.viewModel = viewModel

        DispatchQueue.main.async {
            self.nameLabel.text = viewModel.shortRecipe.name
            self.startingFromLabel.text = viewModel.shortRecipe.startingFrom
            self.premiumImageView.isHidden = viewModel.shortRecipe.isFree || RevenueCatService.shared.hasUnlockedPro
            self.imageContainerView.roundCorners(cornerRadius: .smallCornerRadius)
            self.unavailableView.roundCorners(cornerRadius: .smallCornerRadius)
            self.newView.roundCorners(cornerRadius: self.newView.frame.height/2, borderWidth: 1, borderColor: .white)
            self.newView.isHidden = !viewModel.shortRecipe.isNew
            self.seasonalView.isHidden = !viewModel.shortRecipe.isSeasonal
            self.seasonalView.roundCornersSimplified(cornerRadius: .smallCornerRadius/2, borderWidth: 1, borderColor: .white)
            self.favoriteImageView.isHidden = !RevenueCatService.shared.hasUnlockedPro
            self.favoriteImageView.image = viewModel.shortRecipe.isFavorite ? .init(named: "heart_full") : .init(named: "heart_empty")

            if !(viewModel.shortRecipe.isFree) && !RevenueCatService.shared.hasUnlockedPro {
                self.unavailableView.isHidden = false
            }

            guard let image = viewModel.shortRecipe.image, !image.isEmpty
            else { return }
            let reference = StorageService.shared.getReferenceFor(path: image)
            self.foodImageView.sd_setImage(with: reference, placeholderImage: nil)
        }
    }

    @IBAction func toggleFavorite() {
        if RevenueCatService.shared.hasUnlockedPro {
            let isFavorite = viewModel?.shortRecipe.isFavorite ?? false
            if isFavorite {
                UserDefaultsService.removeRecipeFromFavorite(viewModel?.shortRecipe.id ?? "")
            } else {
                UserDefaultsService.addRecipeToFavorite(viewModel?.shortRecipe.id ?? "")
            }
            favoriteImageView.image = !isFavorite ? .init(named: "heart_full") : .init(named: "heart_empty")
            favoriteImageView.bounce()
        }
    }

}
