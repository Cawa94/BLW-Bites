//
//  AgeDictionary.swift
//  weaning
//
//  Created by Yuri Cavallin on 25/2/23.
//

import Foundation

public struct AgeDictionary: Codable {

    let first: AgeSegment?
    let second: AgeSegment?
    let third: AgeSegment?
    let fourth: AgeSegment?

    enum CodingKeys: String, CodingKey {
        case first
        case second
        case third
        case fourth
    }

    init(data: [String: Any]) {
        self.first = data["first"] as? AgeSegment
        self.second = data["second"] as? AgeSegment
        self.third = data["third"] as? AgeSegment
        self.fourth = data["fourth"] as? AgeSegment
    }

}
