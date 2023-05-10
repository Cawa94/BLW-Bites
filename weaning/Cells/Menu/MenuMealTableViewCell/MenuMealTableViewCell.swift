//
//  MenuMealTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 15/3/23.
//

protocol MenuMealDelegate: AnyObject {

    func selectedElement(foodId: String?, recipeId: String?, cellIndexPath: IndexPath, stackViewDishTag: Int)

}

import UIKit

class MenuMealTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dishesStackView: UIStackView!

    private weak var delegate: MenuMealDelegate?
    private var viewModel: MenuMealTableViewModel?

    public var publicStackView: UIStackView {
        dishesStackView
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        for subView in dishesStackView.subviews {
            dishesStackView.removeArrangedSubview(subView)
            subView.removeFromSuperview()
        }
    }

    func configureWith(_ viewModel: MenuMealTableViewModel) {
        self.viewModel = viewModel

        titleLabel.text = viewModel.title
        self.delegate = viewModel.delegate

        for dish in viewModel.dishes.enumerated() {
            appendDish(dish.element, hideSeparator: dish.offset == viewModel.dishes.count - 1, tag: dish.offset)
        }

        contentContainerView.drawShadow()
    }

    func appendDish(_ menuDish: MenuDish, hideSeparator: Bool, tag: Int) {
        let dishView = MenuDishView()
        dishView.tag = tag
        dishView.configureWith(.init(menuDish: menuDish, hideSeparator: hideSeparator, tapHandler: {
            guard let cellIndexPath = self.viewModel?.indexPath
                else { return }
            if menuDish.isFood ?? false {
                self.delegate?.selectedElement(foodId: menuDish.id, recipeId: nil, cellIndexPath: cellIndexPath, stackViewDishTag: tag)
            } else {
                self.delegate?.selectedElement(foodId: nil, recipeId: menuDish.id, cellIndexPath: cellIndexPath, stackViewDishTag: tag)
            }
        }))
        dishesStackView.addArrangedSubview(dishView)
    }

}
