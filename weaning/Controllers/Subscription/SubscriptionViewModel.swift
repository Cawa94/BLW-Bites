//
//  SubscriptionViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 15/3/23.
//

import Foundation
import StoreKit

struct SubscriptionViewModel {

    var subscriptions: [Subscription]
    var products: [Product]

    init() {
        subscriptions = []
        products = []
    }

}
