//
//  MenuMealTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 15/3/23.
//

private extension CGFloat {

    static let adjustmentHeight: CGFloat = 30

}

import UIKit

class MenuMealTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dishesStackView: UIStackView!
    @IBOutlet private weak var dishesStackViewHeightConstraint: NSLayoutConstraint!

    private var viewModel: MenuMealTableViewModel?

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

        // var height: CGFloat = 0
        for dish in viewModel.dishes {
            // height += .adjustmentHeight
            appendDish(dish)
        }

        // dishesStackViewHeightConstraint.constant = height
        contentContainerView.drawShadow()
    }

    func appendDish(_ menuDish: MenuDish) {
        let dishView = MenuDishView()
        dishView.configureWith(.init(menuDish: menuDish, tapHandler: {
            if menuDish.isFood ?? false, let foodId = menuDish.id {
                NavigationService.push(viewController: NavigationService.foodViewController(foodId: foodId))
            } else if let recipeId = menuDish.id {
                NavigationService.push(viewController: NavigationService.recipeViewController(recipeId: recipeId))
            }
        }))
        // label.heightAnchor.constraint(equalToConstant: .adjustmentHeight).isActive = true
        // label.widthAnchor.constraint(equalToConstant: dishesStackView.bounds.width).isActive = true
        dishesStackView.addArrangedSubview(dishView)
    }

}
