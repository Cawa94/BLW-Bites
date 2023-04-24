//
//  FoodHeaderTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 19/2/23.
//

import UIKit

class FoodTitleTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var startingFromLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var descriptionTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var descriptionTextViewHeightConstraint: NSLayoutConstraint!

    func configureWith(_ food: Food) {
        nameLabel.text = food.name
        startingFromLabel.text = food.startingFrom
        descriptionTextView.attributedText = food.description?.htmlToAttributedString(size: 18)
        descriptionTopConstraint.constant = food.hasDescription ? 20 : 0
        descriptionTextViewHeightConstraint.constant = food.hasDescription ? descriptionTextView.contentSize.height : 0
    }

}
