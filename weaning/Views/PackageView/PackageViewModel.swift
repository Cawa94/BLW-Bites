//
//  PackageViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 16/3/23.
//

import Foundation
import RevenueCat

struct PackageViewModel {

    typealias TapHandler = () -> Void

    let package: Package
    let hasFreeTrial: Bool
    let percentage: String?
    let tapHandler: TapHandler

    init(package: Package,
         hasFreeTrial: Bool = false,
         percentage: String? = nil,
         tapHandler: @escaping TapHandler) {
        self.package = package
        self.hasFreeTrial = hasFreeTrial
        self.percentage = percentage
        self.tapHandler = tapHandler
    }

}
