//
//  ProductView.swift
//  weaning
//
//  Created by Yuri Cavallin on 16/3/23.
//

import UIKit
import StoreKit

class ProductView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!

    private var viewModel: ProductViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("ProductView",
                                 owner: self,
                                 options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.drawShadow()
    }

    func configureWith(_ viewModel: ProductViewModel) {
        self.viewModel = viewModel

        nameLabel.text = viewModel.product.displayName
        priceLabel.text = viewModel.product.displayPrice
    }

    @IBAction func startPurchasing() {
        viewModel?.tapHandler()
    }

}
