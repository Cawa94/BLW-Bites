//
//  HomepageHeaderTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 6/3/23.
//

import UIKit

class HomepageHeaderTableViewCell: UITableViewCell {

    private var viewModel: HomepageHeaderTableViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureWith(_ viewModel: HomepageHeaderTableViewModel) {
        self.viewModel = viewModel
    }

    @IBAction func openProfilePage() {
        viewModel?.tapHandler()
    }

}
