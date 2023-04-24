//
//  RecipeTitleTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 1/3/23.
//

import UIKit

class RecipeTitleTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var startingFromLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var descriptionTextViewHeightConstraint: NSLayoutConstraint!

    func configureWith(_ recipe: Recipe) {
        nameLabel.text = recipe.name
        startingFromLabel.text = recipe.startingFrom
        descriptionTextView.attributedText = recipe.description?.htmlToAttributedString(size: 18)
        descriptionTextViewHeightConstraint.constant = recipe.hasDescription ? descriptionTextView.contentSize.height : 0
    }

}
