//
//  RecipeInfoTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 1/3/23.
//

import UIKit

class RecipeInfoTableViewCell: UITableViewCell {

    @IBOutlet private weak var sectionTitleLabel: UILabel!
    @IBOutlet private weak var sectionTextView: UITextView!
    @IBOutlet private weak var sectionTextViewHeightConstraint: NSLayoutConstraint!

    func configureWith(title: String, text: String) {
        sectionTitleLabel.text = title
        sectionTextView.attributedText = text.htmlToAttributedString(size: 18)
        sectionTextViewHeightConstraint.constant = sectionTextView.contentSize.height
    }

}
