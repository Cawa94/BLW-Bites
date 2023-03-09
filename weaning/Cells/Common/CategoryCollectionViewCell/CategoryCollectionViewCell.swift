//
//  FoodCategoryCollectionViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 18/2/23.
//

import UIKit
import FirebaseStorageUI

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var categoryImageView: UIImageView!

    static let defaultHeight: CGFloat = 45

    override func prepareForReuse() {
        super.prepareForReuse()

        backgroundColor = .white
    }

    func configureWithFoodCategory(_ foodCategory: FoodCategory, isSelected: Bool) {
        self.nameLabel.text = foodCategory.name
        self.categoryImageView.image = UIImage(named: foodCategory.imageName)
        self.nameLabel.textColor = isSelected ? .white : .black
        self.backgroundColor = isSelected ? .systemTeal : .white

        roundCornersSimplified(cornerRadius: frame.height/2)
    }

    func configureWithRecipeCategory(_ recipeCategory: RecipeCategory, isSelected: Bool) {
        self.nameLabel.text = recipeCategory.name
        self.categoryImageView.image = UIImage(named: recipeCategory.imageName)
        self.nameLabel.textColor = isSelected ? .white : .black
        self.backgroundColor = isSelected ? .systemTeal : .white

        roundCornersSimplified(cornerRadius: frame.height/2)
    }

}
