//
//  Date+Extension.swift
//  weaning
//
//  Created by Yuri Cavallin on 26/6/23.
//

import Foundation

extension Date {

    var toString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: Date.now)
    }

}
