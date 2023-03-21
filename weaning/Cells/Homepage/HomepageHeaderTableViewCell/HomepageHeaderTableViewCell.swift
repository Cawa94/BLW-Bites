//
//  HomepageHeaderTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 6/3/23.
//

import UIKit

class HomepageHeaderTableViewCell: UITableViewCell {

    @IBOutlet private var purchaseViewHeighConstraint: NSLayoutConstraint!
    @IBOutlet private var bottomSpaceConstraint: NSLayoutConstraint!

    private var viewModel: HomepageHeaderTableViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()

        purchaseViewHeighConstraint.constant = PurchaseManager.shared.hasUnlockedPro ? 0 : 175
        bottomSpaceConstraint.constant = PurchaseManager.shared.hasUnlockedPro ? 0 : 40
    }

    func configureWith(_ viewModel: HomepageHeaderTableViewModel) {
        self.viewModel = viewModel
    }

    @IBAction func openSubscriptionPage() {
        viewModel?.tapHandler()
    }

}
