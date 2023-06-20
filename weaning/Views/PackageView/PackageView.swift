//
//  PackageView.swift
//  weaning
//
//  Created by Yuri Cavallin on 16/3/23.
//

import UIKit
import StoreKit

class PackageView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!

    private var viewModel: PackageViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("PackageView",
                                 owner: self,
                                 options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.drawShadow()
    }

    func configureWith(_ viewModel: PackageViewModel) {
        self.viewModel = viewModel

        nameLabel.text = viewModel.package.offeringIdentifier
        priceLabel.text = viewModel.package.localizedPriceString
    }

    @IBAction func startPurchasing() {
        viewModel?.tapHandler()
    }

}
