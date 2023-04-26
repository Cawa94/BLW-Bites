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
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var premiumImageView: UIImageView!

    private var viewModel: MenuSelectorTableViewModel?

    func configureWith(_ viewModel: MenuSelectorTableViewModel) {
        self.viewModel = viewModel

        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        mainImageView.image = UIImage(named: viewModel.image)
        premiumImageView.isHidden = !(viewModel.isPremium) || PurchaseManager.shared.hasUnlockedPro

        contentContainerView.drawShadow()
    }

    @IBAction func openMenu() {
        viewModel?.tapHandler()
    }

}
