//
//  HomepageElementsTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 6/3/23.
//

import UIKit

protocol HomepageFoodsDelegate: AnyObject {

    func selectedElement(food: Food?, elementIndexPath: IndexPath, cellIndexPath: IndexPath)

}

class HomepageFoodsTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var mainCollectionView: UICollectionView!
    @IBOutlet private weak var mainCollectionViewHeightConstraint: NSLayoutConstraint!

    public var publicCollectionView: UICollectionView {
        mainCollectionView
    }

    private weak var delegate: HomepageFoodsDelegate?
    var foods: [Food]?
    var indexPath: IndexPath?

    func configureWith(foods: [Food]? = nil,
                       title: String,
                       indexPath: IndexPath,
                       delegate: HomepageFoodsDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        self.foods = foods
        self.titleLabel.text = title

        mainCollectionView.register(UINib(nibName:"ShortFoodCollectionViewCell", bundle: nil),
                                    forCellWithReuseIdentifier:"ShortFoodCollectionViewCell")

        if !(foods?.isEmpty ?? true) {
            let cellsWidth = CGFloat(self.mainCollectionView.bounds.width * CGFloat.homepageCellsSpacePercentage)
            let width = cellsWidth / 2
            let height = Double(width) * ShortFoodCollectionViewCell.heightWidthRatio
            self.mainCollectionViewHeightConstraint.constant = height

            DispatchQueue.main.async {
                self.mainCollectionView.reloadData()
            }
        }
    }

}

extension HomepageFoodsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortFoodCollectionViewCell",
                                                            for: indexPath) as? ShortFoodCollectionViewCell,
              let food = foods?[indexPath.row]
            else { return UICollectionViewCell() }
        cell.configureWith(.init(shortFood: food.asShortFood, food: food, inHomepage: true), imageCornerRadius: 142/2)
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
        let height = Double(width) * ShortFoodCollectionViewCell.heightWidthRatio
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
        guard let food = foods?[indexPath.row], let cellIndexPath = self.indexPath
            else { return }
        let isFree = food.isFree
        if isFree || RevenueCatService.shared.hasUnlockedPro {
            delegate?.selectedElement(food: food, elementIndexPath: indexPath, cellIndexPath: cellIndexPath)
        } else {
            NavigationService.openLoginOrSubscription()
        }
    }

}
