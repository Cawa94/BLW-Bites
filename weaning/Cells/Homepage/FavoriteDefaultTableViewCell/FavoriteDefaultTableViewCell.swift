//
//  FavoriteDefaultTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 6/3/23.
//

import UIKit

class FavoriteDefaultTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var mainCollectionView: UICollectionView!
    @IBOutlet private weak var mainCollectionViewHeightConstraint: NSLayoutConstraint!

    var shortFoods: [ShortFood]?
    var shortRecipes: [ShortRecipe]?

    func configureWith(shortFoods: [ShortFood]? = nil,
                       shortRecipes: [ShortRecipe]? = nil,
                       isFavorites: Bool) {
        self.shortFoods = shortFoods
        self.shortRecipes = shortRecipes
        self.titleLabel.text = shortFoods != nil ? "Popular Foods" : "Popular Recipes"

        mainCollectionView.register(UINib(nibName:"ShortFoodCollectionViewCell", bundle: nil),
                                    forCellWithReuseIdentifier:"ShortFoodCollectionViewCell")
        mainCollectionView.register(UINib(nibName:"ShortRecipeCollectionViewCell", bundle: nil),
                                    forCellWithReuseIdentifier:"ShortRecipeCollectionViewCell")

        DispatchQueue.main.async {
            self.mainCollectionView.reloadData()
        }
    }

}

extension FavoriteDefaultTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if shortFoods != nil {
            return shortFoods?.count ?? 0
        } else {
            return shortRecipes?.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if shortFoods != nil {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortFoodCollectionViewCell",
                                                                for: indexPath) as? ShortFoodCollectionViewCell,
                  let shortFood = shortFoods?[indexPath.row]
                else { return UICollectionViewCell() }
            cell.configureWith(shortFood)
            cell.drawCellShadow()
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortRecipeCollectionViewCell",
                                                                for: indexPath) as? ShortRecipeCollectionViewCell,
                  let shortRecipe = shortRecipes?[indexPath.row]
                else { return UICollectionViewCell() }
            cell.configureWith(shortRecipe)
            cell.drawCellShadow()
            return cell
        }
        
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftInset = 30
        let columnWidth = Int(collectionView.bounds.width) / 2 - leftInset
        let width = columnWidth - (20 / 2)

        return CGSize(width: CGFloat(width), height: ShortFoodCollectionViewCell.defaultHeight)
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
        guard let shortFood = shortFoods?[indexPath.row], let id = shortFood.id
            else { return }
        let foodController = NavigationService.foodViewController(foodId: id)
        NavigationService.push(viewController: foodController)
    }

}
