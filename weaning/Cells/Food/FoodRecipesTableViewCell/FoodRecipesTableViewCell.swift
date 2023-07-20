//
//  FoodRecipesTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 21/3/23.
//

import UIKit

class FoodRecipesTableViewCell: UITableViewCell {

    @IBOutlet private weak var recipesCollectionView: UICollectionView!

    var shortRecipes: [ShortRecipe]?

    func configureWith(shortRecipes: [ShortRecipe]) {
        self.shortRecipes = shortRecipes

        recipesCollectionView.register(UINib(nibName:"ShortRecipeCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier:"ShortRecipeCollectionViewCell")

        DispatchQueue.main.async {
            self.recipesCollectionView.reloadData()
        }
    }

}

extension FoodRecipesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        shortRecipes?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortRecipeCollectionViewCell",
                                                            for: indexPath) as? ShortRecipeCollectionViewCell,
              let shortRecipe = shortRecipes?[indexPath.row]
            else { return UICollectionViewCell() }
        cell.configureWith(.init(shortRecipe: shortRecipe, recipe: nil), imageCornerRadius: 157/2)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsWidth = CGFloat(collectionView.bounds.width * CGFloat.homepageCellsSpacePercentage)
        let width = cellsWidth / 2
        let height = Double(width) * ShortRecipeCollectionViewCell.heightWidthRatio
        return CGSize(width: width, height: CGFloat(height))
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 30, bottom: 10, right: 30)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let shortRecipe = shortRecipes?[indexPath.row], let id = shortRecipe.id
            else { return }
        let recipeController = NavigationService.recipeViewController(recipeId: id, recipe: nil)
        NavigationService.push(viewController: recipeController)
    }

}
