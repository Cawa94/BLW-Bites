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
    @IBOutlet private weak var favoriteImageView: UIImageView!

    static var heightWidthRatio: CGFloat = 1.4375
    private var viewModel: ShortFoodCollectionViewModel?

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

    func configureWith(_ viewModel: ShortFoodCollectionViewModel, imageCornerRadius: CGFloat) {
        self.viewModel = viewModel

        DispatchQueue.main.async {
            self.imageContainerView.roundCorners(cornerRadius: imageCornerRadius, borderWidth: 2.5, borderColor: .mainColor)
            self.unavailableView.roundCorners(cornerRadius: imageCornerRadius, borderWidth: 4, borderColor: .white)
            self.newView.roundCorners(cornerRadius: self.newView.frame.height/2, borderWidth: 1, borderColor: .white)

            self.nameLabel.text = viewModel.shortFood.name
            self.startingFromLabel.text = viewModel.shortFood.startingFrom
            self.premiumImageView.isHidden = viewModel.shortFood.isFree || RevenueCatService.shared.hasUnlockedPro
            self.newView.isHidden = !viewModel.shortFood.isNew
            self.seasonalView.isHidden = !viewModel.shortFood.isSeasonal
            self.favoriteImageView.isHidden = !RevenueCatService.shared.hasUnlockedPro
            self.favoriteImageView.image = viewModel.shortFood.isFavorite ? .init(named: "heart_full") : .init(named: "heart_empty")

            if !(viewModel.shortFood.isFree) && !RevenueCatService.shared.hasUnlockedPro {
                self.unavailableView.isHidden = false
            }

            guard let image = viewModel.shortFood.image, !image.isEmpty
                else { return }
            let reference = StorageService.shared.getReferenceFor(path: image)
            self.foodImageView.sd_setImage(with: reference, placeholderImage: nil)
        }
    }

    @IBAction func toggleFavorite() {
        if RevenueCatService.shared.hasUnlockedPro {
            let isFavorite = viewModel?.shortFood.isFavorite ?? false
            if isFavorite {
                UserDefaultsService.removeFoodFromFavorite(viewModel?.shortFood.id ?? "")
            } else {
                UserDefaultsService.addFoodToFavorite(viewModel?.shortFood.id ?? "")
            }
            favoriteImageView.image = !isFavorite ? .init(named: "heart_full") : .init(named: "heart_empty")
            favoriteImageView.bounce()
        }
    }

}
