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

    static let defaultHeight: CGFloat = 230
    private var viewModel: ShortFoodCollectionViewModel?

    public var publicImageView: UIImageView {
        foodImageView
    }

    public var publicFavoriteImageView: UIImageView {
        favoriteImageView
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        foodImageView.image = nil
        unavailableView.isHidden = true
        newView.isHidden = true
        seasonalView.isHidden = true
    }

    func configureWith(_ viewModel: ShortFoodCollectionViewModel, imageCornerRadius: CGFloat) {
        self.viewModel = viewModel

        nameLabel.text = viewModel.shortFood.name
        startingFromLabel.text = viewModel.shortFood.startingFrom
        premiumImageView.isHidden = viewModel.shortFood.isFree || PurchaseManager.shared.hasUnlockedPro
        imageContainerView.roundCornersSimplified(cornerRadius: imageCornerRadius, borderWidth: 1.5, borderColor: .mainColor)
        unavailableView.roundCornersSimplified(cornerRadius: imageCornerRadius, borderWidth: 4, borderColor: .white)
        newView.roundCornersSimplified(cornerRadius: newView.frame.height/2, borderWidth: 1, borderColor: .white)
        newView.isHidden = !viewModel.shortFood.isNew
        seasonalView.isHidden = !viewModel.shortFood.isSeasonal
        favoriteImageView.isHidden = !PurchaseManager.shared.hasUnlockedPro
        favoriteImageView.image = viewModel.shortFood.isFavorite ? .init(named: "heart_full") : .init(named: "heart_empty")

        if !(viewModel.shortFood.isFree) && !PurchaseManager.shared.hasUnlockedPro {
            self.unavailableView.isHidden = false
        }

        guard let image = viewModel.shortFood.image, !image.isEmpty
            else { return }
        let reference = StorageService.shared.getReferenceFor(path: image)
        foodImageView.sd_setImage(with: reference, placeholderImage: nil)
    }

    @IBAction func toggleFavorite() {
        if PurchaseManager.shared.hasUnlockedPro {
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
