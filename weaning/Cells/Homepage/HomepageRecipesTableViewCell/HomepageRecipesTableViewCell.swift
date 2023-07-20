//
//  HomepageRecipesTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 6/3/23.
//

import UIKit

protocol HomepageRecipesDelegate: AnyObject {

    func selectedElement(recipe: Recipe?, elementIndexPath: IndexPath, cellIndexPath: IndexPath)

}

class HomepageRecipesTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var mainCollectionView: UICollectionView!
    @IBOutlet private weak var mainCollectionViewHeightConstraint: NSLayoutConstraint!

    public var publicCollectionView: UICollectionView {
        mainCollectionView
    }

    private weak var delegate: HomepageRecipesDelegate?
    var recipes: [Recipe]?
    var indexPath: IndexPath?

    func configureWith(recipes: [Recipe]? = nil,
                       title: String,
                       indexPath: IndexPath,
                       delegate: HomepageRecipesDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        self.recipes = recipes
        self.titleLabel.text = title

        mainCollectionView.register(UINib(nibName:"ShortRecipeCollectionViewCell", bundle: nil),
                                    forCellWithReuseIdentifier:"ShortRecipeCollectionViewCell")

        if !(recipes?.isEmpty ?? true) {
            let cellsWidth = CGFloat(self.mainCollectionView.bounds.width * CGFloat.homepageCellsSpacePercentage)
            let width = cellsWidth / 2
            let height = Double(width) * ShortRecipeCollectionViewCell.heightWidthRatio
            self.mainCollectionViewHeightConstraint.constant = height

            DispatchQueue.main.async {
                self.mainCollectionView.reloadData()
            }
        }
    }

}

extension HomepageRecipesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortRecipeCollectionViewCell",
                                                            for: indexPath) as? ShortRecipeCollectionViewCell,
              let recipe = recipes?[indexPath.row]
            else { return UICollectionViewCell() }
        cell.configureWith(.init(shortRecipe: recipe.asShortRecipe, recipe: recipe, inHomepage: true), imageCornerRadius: 142/2)
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
        return .init(top: 0, left: 30, bottom: 0, right: 30)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let recipe = recipes?[indexPath.row], let cellIndexPath = self.indexPath
            else { return }
        let isFree = recipe.isFree
        if isFree || RevenueCatService.shared.hasUnlockedPro {
            delegate?.selectedElement(recipe: recipe, elementIndexPath: indexPath, cellIndexPath: cellIndexPath)
        } else {
            NavigationService.openLoginOrSubscription()
        }
    }

}
