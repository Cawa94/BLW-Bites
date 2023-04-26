//
//  DayCollectionViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/3/23.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var circleView: UIView!
    @IBOutlet private weak var premiumImageView: UIImageView!

    static let defaultHeight: CGFloat = 55

    override func prepareForReuse() {
        super.prepareForReuse()

        circleView.backgroundColor = .mainColor
    }

    func configureWithDay(_ dayNumber: String, isSelected: Bool, isPremium: Bool) {
        numberLabel.text = dayNumber
        numberLabel.textColor = isSelected ? .mainColor : .white
        premiumImageView.isHidden = !(isPremium) || PurchaseManager.shared.hasUnlockedPro

        circleView.backgroundColor = isSelected ? .white : .mainColor
        circleView.roundCornersSimplified(cornerRadius: DayCollectionViewCell.defaultHeight/2, borderWidth: 1, borderColor: .mainColor)
    }

}
