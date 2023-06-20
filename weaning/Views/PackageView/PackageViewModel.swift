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
    let tapHandler: TapHandler

    init(package: Package,
         tapHandler: @escaping TapHandler) {
        self.package = package
        self.tapHandler = tapHandler
    }

}
