//
//  Subscription.swift
//  weaning
//
//  Created by Yuri Cavallin on 15/3/23.
//

import Foundation

public struct Subscription: Codable {

    let id: String?

    enum CodingKeys: String, CodingKey {
        case id
    }

    init(data: [String: Any]) {
        self.id = data["id"] as? String
    }

}
