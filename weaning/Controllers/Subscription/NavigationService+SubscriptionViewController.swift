//
//  NavigationService+SubscriptionViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 15/3/23.
//

import Foundation

extension NavigationService {

    static func subscriptionViewController() -> SubscriptionViewController {
        let controller = SubscriptionViewController(nibName: SubscriptionViewController.xibName,
                                                    bundle: nil)
        controller.viewModel = SubscriptionViewModel()
        return controller
    }

}
