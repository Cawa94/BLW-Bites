//
//  FoodSectionTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 19/2/23.
//

import UIKit

protocol FoodSectionDelegate: AnyObject {

    func toggleContent()

}

class FoodSectionTableViewCell: UITableViewCell {

    @IBOutlet private weak var sectionTitleLabel: UILabel!
    @IBOutlet private weak var toggleView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var sectionTextView: UITextView!
    @IBOutlet private weak var sectionTextViewHeightConstraint: NSLayoutConstraint!

    private weak var delegate: FoodSectionDelegate?
    private var showContent = false

    override func awakeFromNib() {
        super.awakeFromNib()

        toggleView.drawShadow(cornerRadius: .smallCornerRadius)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        showContent = false
    }

    func configureWith(infoSection: InfoSection, delegate: FoodSectionDelegate) {
        self.delegate = delegate
        sectionTitleLabel.text = infoSection.title
        sectionTextView.attributedText = infoSection.description?.htmlToAttributedString(size: 18)
    }

    @IBAction func toggleVisibility() {
        showContent = !showContent

        if showContent {
            sectionTextViewHeightConstraint.constant = sectionTextView.contentSize.height
            iconImageView.image = .init(systemName: "minus")
        } else {
            sectionTextViewHeightConstraint.constant = 0
            iconImageView.image = .init(systemName: "plus")
        }

        delegate?.toggleContent()
    }

}
