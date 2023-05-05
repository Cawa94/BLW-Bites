//
//  HomepageElementsTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 6/3/23.
//

import UIKit

protocol HomepageElementsDelegate: AnyObject {

    func selectedElement(foodId: String?, recipeId: String?,
                         elementIndexPath: IndexPath, cellIndexPath: IndexPath)

}

class HomepageElementsTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var mainCollectionView: UICollectionView!
    @IBOutlet private weak var mainCollectionViewHeightConstraint: NSLayoutConstraint!

    public var publicCollectionView: UICollectionView {
        mainCollectionView
    }

    private weak var delegate: HomepageElementsDelegate?
    var shortFoods: [ShortFood]?
    var shortRecipes: [ShortRecipe]?
    var mergedContent: [FoodOrRecipe] = []
    var indexPath: IndexPath?

    func configureWith(shortFoods: [ShortFood]? = nil,
                       shortRecipes: [ShortRecipe]? = nil,
                       title: String,
                       indexPath: IndexPath,
                       delegate: HomepageElementsDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        self.shortFoods = shortFoods
        self.shortRecipes = shortRecipes
        self.titleLabel.text = title

        mainCollectionView.register(UINib(nibName:"ShortFoodCollectionViewCell", bundle: nil),
                                    forCellWithReuseIdentifier:"ShortFoodCollectionViewCell")
        mainCollectionView.register(UINib(nibName:"ShortRecipeCollectionViewCell", bundle: nil),
                                    forCellWithReuseIdentifier:"ShortRecipeCollectionViewCell")

        for food in shortFoods ?? [] {
            mergedContent.append(FoodOrRecipe.initFromFood(food))
        }

        for recipe in shortRecipes ?? [] {
            mergedContent.append(FoodOrRecipe.initFromRecipe(recipe))
        }

        mergedContent.shuffle()

        DispatchQueue.main.async {
            self.mainCollectionView.reloadData()
        }
    }

}

extension HomepageElementsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mergedContent.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if mergedContent[indexPath.row].isFood ?? false {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortFoodCollectionViewCell",
                                                                for: indexPath) as? ShortFoodCollectionViewCell
                else { return UICollectionViewCell() }
            let shortFood = mergedContent[indexPath.row].initFood()
            cell.configureWith(shortFood, imageCornerRadius: 142/2)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortRecipeCollectionViewCell",
                                                                for: indexPath) as? ShortRecipeCollectionViewCell
                else { return UICollectionViewCell() }
            let shortRecipe = mergedContent[indexPath.row].initRecipe()
            cell.configureWith(shortRecipe, imageCornerRadius: 142/2)
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
        let width = columnWidth - (15)
        return CGSize(width: CGFloat(width),
                      height: ShortFoodCollectionViewCell.defaultHeight)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 30, bottom: 0, right: 30)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if mergedContent[indexPath.row].isFood ?? false {
            guard let id = mergedContent[indexPath.row].id, let isFree = mergedContent[indexPath.row].isFree, let cellIndexPath = self.indexPath
                else { return }
            if isFree || PurchaseManager.shared.hasUnlockedPro {
                delegate?.selectedElement(foodId: id, recipeId: nil, elementIndexPath: indexPath, cellIndexPath: cellIndexPath)
            } else {
                NavigationService.present(viewController: NavigationService.subscriptionViewController())
            }
        } else {
            guard let id = mergedContent[indexPath.row].id, let isFree = mergedContent[indexPath.row].isFree, let cellIndexPath = self.indexPath
                else { return }
            if isFree || PurchaseManager.shared.hasUnlockedPro {
                delegate?.selectedElement(foodId: nil, recipeId: id, elementIndexPath: indexPath, cellIndexPath: cellIndexPath)
            } else {
                NavigationService.present(viewController: NavigationService.subscriptionViewController())
            }
        }
    }

}
