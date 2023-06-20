//
//  HomepageElementsTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 6/3/23.
//

import UIKit

protocol HomepageElementsDelegate: AnyObject {

    func selectedElement(food: Food?, recipe: Recipe?, elementIndexPath: IndexPath, cellIndexPath: IndexPath)

}

class HomepageElementsTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var mainCollectionView: UICollectionView!
    @IBOutlet private weak var mainCollectionViewHeightConstraint: NSLayoutConstraint!

    public var publicCollectionView: UICollectionView {
        mainCollectionView
    }

    private weak var delegate: HomepageElementsDelegate?
    var foods: [Food]?
    var recipes: [Recipe]?
    var isFoodsCollection = true
    var indexPath: IndexPath?

    func configureWith(foods: [Food]? = nil,
                       recipes: [Recipe]? = nil,
                       title: String,
                       indexPath: IndexPath,
                       delegate: HomepageElementsDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        self.foods = foods
        self.recipes = recipes
        self.isFoodsCollection = !(foods?.isEmpty ?? true)
        self.titleLabel.text = title

        mainCollectionView.register(UINib(nibName:"ShortFoodCollectionViewCell", bundle: nil),
                                    forCellWithReuseIdentifier:"ShortFoodCollectionViewCell")
        mainCollectionView.register(UINib(nibName:"ShortRecipeCollectionViewCell", bundle: nil),
                                    forCellWithReuseIdentifier:"ShortRecipeCollectionViewCell")

        DispatchQueue.main.async {
            self.mainCollectionView.reloadData()
        }
    }

}

extension HomepageElementsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFoodsCollection ? foods?.count ?? 0 : recipes?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isFoodsCollection {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortFoodCollectionViewCell",
                                                                for: indexPath) as? ShortFoodCollectionViewCell,
                  let food = foods?[indexPath.row]
                else { return UICollectionViewCell() }
            cell.configureWith(.init(shortFood: food.asShortFood, food: food, inHomepage: true), imageCornerRadius: 142/2)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortRecipeCollectionViewCell",
                                                                for: indexPath) as? ShortRecipeCollectionViewCell,
                  let recipe = recipes?[indexPath.row]
                else { return UICollectionViewCell() }
            cell.configureWith(.init(shortRecipe: recipe.asShortRecipe, recipe: recipe, inHomepage: true), imageCornerRadius: 142/2)
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
        if isFoodsCollection {
            guard let food = foods?[indexPath.row], let cellIndexPath = self.indexPath
                else { return }
            let isFree = food.isFree
            if isFree || RevenueCatService.shared.hasUnlockedPro {
                delegate?.selectedElement(food: food, recipe: nil, elementIndexPath: indexPath, cellIndexPath: cellIndexPath)
            } else {
                NavigationService.openLoginOrSubscription()
            }
        } else {
            guard let recipe = recipes?[indexPath.row], let cellIndexPath = self.indexPath
                else { return }
            let isFree = recipe.isFree
            if isFree || RevenueCatService.shared.hasUnlockedPro {
                delegate?.selectedElement(food: nil, recipe: recipe, elementIndexPath: indexPath, cellIndexPath: cellIndexPath)
            } else {
                NavigationService.openLoginOrSubscription()
            }
        }
    }

}
