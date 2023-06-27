//
//  SubscriptionViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 15/3/23.
//

import Foundation
import RevenueCat

struct SubscriptionViewModel {

    var firstSelected = false
    var hasFreeTrial: Bool
    var firstPackage: Package?
    var secondPackage: Package?

    init() {
        self.hasFreeTrial = RevenueCatService.shared.hasFreeTrial
        self.firstPackage = RevenueCatService.shared.packages?[0]
        self.secondPackage = RevenueCatService.shared.packages?[1]
    }

}
