//
//  ButtonView.swift
//  weaning
//
//  Created by Yuri Cavallin on 14/6/23.
//

import UIKit
import StoreKit

class ButtonView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var titleLabel: UILabel!

    private var viewModel: ButtonViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("ButtonView",
                                 owner: self,
                                 options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.drawShadow()
    }

    func configureWith(_ viewModel: ButtonViewModel) {
        self.viewModel = viewModel

        titleLabel.font = .extraBoldFontOf(size: viewModel.fontSize)
        titleLabel.text = viewModel.title
    }

    @IBAction func tapAction() {
        viewModel?.tapHandler()
    }

}
