//
//  TickView.swift
//  weaning
//
//  Created by Yuri Cavallin on 21/7/23.
//

import UIKit
import StoreKit

class TickView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("TickView",
                                 owner: self,
                                 options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    func configureWith(_ title: NSMutableAttributedString?) {
        titleLabel.attributedText = title
    }

}
