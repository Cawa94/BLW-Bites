//
//  MenuSelectorTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/3/23.
//

import UIKit

class MenuSelectorTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var monthLabelConstraint: NSLayoutConstraint!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var premiumImageView: UIImageView!
    @IBOutlet private weak var newView: UIView!

    private var viewModel: MenuSelectorTableViewModel?

    override func prepareForReuse() {
        super.prepareForReuse()

        newView.isHidden = true
    }

    func configureWith(_ viewModel: MenuSelectorTableViewModel) {
        self.viewModel = viewModel

        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        mainImageView.image = UIImage(named: viewModel.image)
        premiumImageView.isHidden = !(viewModel.isPremium) || PurchaseManager.shared.hasUnlockedPro
        newView.roundCornersSimplified(cornerRadius: newView.frame.height/2, borderWidth: 1, borderColor: .white)
        newView.isHidden = !viewModel.isNew
        monthLabel.text = viewModel.month
        monthLabelConstraint.constant = viewModel.month != nil ? 30 : 0

        contentContainerView.drawShadow()
    }

    @IBAction func openMenu() {
        viewModel?.tapHandler()
    }

}
