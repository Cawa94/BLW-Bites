//
//  HomepageHeaderTableViewModel.swift
//  weaning
//
//  Created by Yuri Cavallin on 21/3/23.
//

import Foundation

struct HomepageHeaderTableViewModel {

    typealias TapHandler = () -> Void

    let tapHandler: TapHandler

    init(tapHandler: @escaping TapHandler) {
        self.tapHandler = tapHandler
    }

}
