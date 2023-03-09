//
//  Optional+Extension.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import Foundation

extension Optional {

    func unwrap(failureDescription: String) -> Wrapped {
        guard let unwrapped = self else {
            fatalError(failureDescription)
        }

        return unwrapped
    }

}
