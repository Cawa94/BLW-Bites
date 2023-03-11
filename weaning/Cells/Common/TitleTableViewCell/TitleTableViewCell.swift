//
//  TitleTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/3/23.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!

    func configureWith(_ text: String) {
        titleLabel.text = text
    }

}
