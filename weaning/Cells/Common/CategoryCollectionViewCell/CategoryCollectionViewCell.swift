//
//  FoodCategoryCollectionViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 18/2/23.
//

import UIKit
import FirebaseStorageUI

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var unavailableView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var categoryImageView: UIImageView!

    static let defaultHeight: CGFloat = 45
    private var viewModel: CategoryCollectionViewModel?

    override func prepareForReuse() {
        super.prepareForReuse()

        backgroundColor = .white
    }

    func configureWithFoodCategory(_ viewModel: CategoryCollectionViewModel, isSelected: Bool) {
        self.viewModel = viewModel

        self.nameLabel.text = viewModel.foodCategory?.name
        if viewModel.isFavorites {
            self.categoryImageView.image = UIImage(named: isSelected ? "heart_white" : "heart_full")
        } else {
            self.categoryImageView.image = UIImage(named: viewModel.foodCategory?.imageName ?? "")
        }
        self.nameLabel.textColor = isSelected ? .white : .textColor
        self.backgroundColor = isSelected ? .mainColor : .white
        unavailableView.isHidden = !viewModel.isFavorites || PurchaseManager.shared.hasUnlockedPro
        unavailableView.roundCornersSimplified(cornerRadius: frame.height/2, borderWidth: 1, borderColor: isSelected ? .white : .mainColor)
        roundCornersSimplified(cornerRadius: frame.height/2, borderWidth: 1, borderColor: isSelected ? .white : .mainColor)
    }

    func configureWithRecipeCategory(_ viewModel: CategoryCollectionViewModel, isSelected: Bool) {
        self.viewModel = viewModel

        self.nameLabel.text = viewModel.recipeCategory?.name
        if viewModel.isFavorites {
            self.categoryImageView.image = UIImage(named: isSelected ? "heart_white" : "heart_full")
        } else {
            self.categoryImageView.image = UIImage(named: viewModel.recipeCategory?.imageName ?? "")
        }
        self.nameLabel.textColor = isSelected ? .white : .textColor
        self.backgroundColor = isSelected ? .mainColor : .white
        unavailableView.isHidden = !viewModel.isFavorites || PurchaseManager.shared.hasUnlockedPro
        unavailableView.roundCornersSimplified(cornerRadius: frame.height/2, borderWidth: 1, borderColor: isSelected ? .white : .mainColor)
        roundCornersSimplified(cornerRadius: frame.height/2, borderWidth: 1, borderColor: isSelected ? .white : .mainColor)
    }

}
