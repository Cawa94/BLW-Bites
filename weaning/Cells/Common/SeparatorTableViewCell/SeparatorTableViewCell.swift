//
//  SeparatorTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 25/2/23.
//

import UIKit

class SeparatorTableViewCell: UITableViewCell {

    @IBOutlet private weak var viewHeightConstraint: NSLayoutConstraint!

    func configureWith(_ height: CGFloat) {
        viewHeightConstraint.constant = height
    }

}
