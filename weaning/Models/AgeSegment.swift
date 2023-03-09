//
//  AgeSegment.swift
//  weaning
//
//  Created by Yuri Cavallin on 25/2/23.
//

import Foundation

public struct AgeSegment: Codable {

    let months: String?
    let description: String?
    let pictures: [String]?
    let video: String?

    enum CodingKeys: String, CodingKey {
        case months
        case description
        case pictures
        case video
    }

    init(data: [String: Any]) {
        self.months = data["months"] as? String
        self.description = data["description"] as? String
        self.pictures = data["pictures"] as? [String]
        self.video = data["video"] as? String
    }

}
