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
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var discountPercentageLabel: UILabel!
    @IBOutlet private var discountView: UIView!
    @IBOutlet private var freeTrialView: UIView!
    @IBOutlet private var perMonthLabel: UILabel!
    @IBOutlet private var strikeoutView: UIView!
    @IBOutlet private var priceCenterConstraint: NSLayoutConstraint!

    private var viewModel: PackageViewModel?

    public var publicContainerView: UIView {
        containerView
    }

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

        containerView.drawShadow()
        discountView.roundCornersSimplified(cornerRadius: .smallCornerRadius, borderWidth: 1, borderColor: .white)
    }

    func configureWith(_ viewModel: PackageViewModel) {
        self.viewModel = viewModel

        if viewModel.package.id == "$rc_six_month" || viewModel.package.id == "$rc_annual" {
            discountView.isHidden = false
            freeTrialView.isHidden = viewModel.hasFreeTrial ? false : true
            discountPercentageLabel.text = viewModel.percentage
            priceCenterConstraint.constant = viewModel.hasFreeTrial ? 0 : 10
            containerView.roundCornersSimplified(cornerRadius: .defaultCornerRadius, borderWidth: 1, borderColor: .mainColor)

            perMonthLabel.text = viewModel.fullPrice
            strikeoutView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 25)
        } else {
            containerView.backgroundColor = .backgroundColor1
            nameLabel.textColor = .textColor
            priceLabel.textColor = .textColor
            perMonthLabel.textColor = .textColor
            containerView.roundCornersSimplified(cornerRadius: .defaultCornerRadius, borderWidth: 1, borderColor: .mainColor)
        }
        nameLabel.text = viewModel.package.storeProduct.localizedTitle
        priceLabel.text = "\(viewModel.package.storeProduct.price) \(viewModel.package.storeProduct.currencyCode ?? "")"
    }

    @IBAction func startPurchasing() {
        viewModel?.tapHandler()
    }

}
