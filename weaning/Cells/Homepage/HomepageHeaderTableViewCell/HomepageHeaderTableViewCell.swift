//
//  HomepageHeaderTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 6/3/23.
//

import UIKit

class HomepageHeaderTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var subscribeButton: ButtonView!
    @IBOutlet private weak var subscribeButtonHeighConstraint: NSLayoutConstraint!
    @IBOutlet private weak var subscribeButtonBottomConstraint: NSLayoutConstraint!

    private var viewModel: HomepageHeaderTableViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureWith(_ viewModel: HomepageHeaderTableViewModel) {
        self.viewModel = viewModel

        /*titleLabel.attributedText = "HOME_TITLE".localized().replaceBoldParts(
            originalString: "HOME_TITLE".localized(),
            mutableString: NSMutableAttributedString(string: "HOME_TITLE".localized()),
            fontSize: 25)*/
        subtitleLabel.attributedText = "With <b>Baby-Led Weaning</b> you can provide to your baby <b>all the nutrition necessary</b> and introduce solid foods with easy and fun!".htmlToAttributedString(nunito: true)

        if RevenueCatService.shared.hasUnlockedPro {
            subscribeButton.isHidden = true
            subscribeButtonHeighConstraint.constant = 0
            subscribeButtonBottomConstraint.constant = 0
        } else {
            subscribeButton.configureWith(.init(title: "PROFILE_SUBSCRIBE_NOW".localized(), tapHandler: {
                NavigationService.openLoginOrSubscription()
            }))
            subscribeButtonHeighConstraint.constant = 60
            subscribeButtonBottomConstraint.constant = 20
        }
    }

    @IBAction func openProfilePage() {
        viewModel?.tapHandler()
    }

}
