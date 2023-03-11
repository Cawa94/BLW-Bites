//
//  DayCollectionViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/3/23.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var dayLabel: UILabel!

    static let defaultHeight: CGFloat = 85

    override func prepareForReuse() {
        super.prepareForReuse()

        backgroundColor = .green
    }

    func configureWithDay(_ dayNumber: String, isSelected: Bool) {
        numberLabel.text = dayNumber
        numberLabel.textColor = isSelected ? .systemGreen : .white
        dayLabel.textColor = isSelected ? .systemGreen : .white

        backgroundColor = isSelected ? .white : .systemGreen

        roundCornersSimplified(cornerRadius: .smallCornerRadius)
    }

}
