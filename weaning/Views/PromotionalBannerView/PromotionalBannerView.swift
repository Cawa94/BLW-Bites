//
//  PromotionalBannerView.swift
//  weaning
//
//  Created by Yuri Cavallin on 14/6/23.
//

import UIKit
import StoreKit

class PromotionalBannerView: UIView {

    @IBOutlet private var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("PromotionalBannerView",
                                 owner: self,
                                 options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    @IBAction func showSubscriptionPage() {
        NavigationService.openLoginOrSubscription()
    }

}
