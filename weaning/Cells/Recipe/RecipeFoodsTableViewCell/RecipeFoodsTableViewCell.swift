//
//  RecipeFoodsTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 6/3/23.
//

import UIKit

class RecipeFoodsTableViewCell: UITableViewCell {

    @IBOutlet private weak var foodsCollectionView: UICollectionView!

    var shortFoods: [ShortFood]?

    func configureWith(shortFoods: [ShortFood]) {
        self.shortFoods = shortFoods

        foodsCollectionView.register(UINib(nibName:"ShortFoodCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier:"ShortFoodCollectionViewCell")

        DispatchQueue.main.async {
            self.foodsCollectionView.reloadData()
        }
    }

}

extension RecipeFoodsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        shortFoods?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortFoodCollectionViewCell",
                                                            for: indexPath) as? ShortFoodCollectionViewCell,
              let shortFood = shortFoods?[indexPath.row]
            else { return UICollectionViewCell() }
        cell.configureWith(.init(shortFood: shortFood, food: nil), imageCornerRadius: 157/2)
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
        let foodController = NavigationService.foodViewController(foodId: id, food: nil)
        NavigationService.push(viewController: foodController)
    }

}
