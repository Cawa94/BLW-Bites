//
//  InfoSection.swift
//  weaning
//
//  Created by Yuri Cavallin on 25/2/23.
//

import Foundation

public struct InfoSection: Codable {

    let title: String?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case title
        case description
    }

    init(data: [String: Any]) {
        self.title = data["title"] as? String
        self.description = data["description"] as? String
    }

}
