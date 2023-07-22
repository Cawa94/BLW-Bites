//
//  TitleTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/3/23.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    func configureWith(_ title: String, subtitle: String? = nil) {
        titleLabel.text = title
        subtitleLabel.attributedText = subtitle?.htmlToAttributedString(nunito: true)
    }

}
