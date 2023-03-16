//
//  ProductViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 16/3/23.
//

import Foundation
import StoreKit

struct ProductViewModel {

    typealias TapHandler = () -> Void

    let product: Product
    let tapHandler: TapHandler

    init(product: Product,
         tapHandler: @escaping TapHandler) {
        self.product = product
        self.tapHandler = tapHandler
    }

}
