//
//  ShortFood.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import Foundation

public struct ShortFood: Codable {

    let id: String?
    let name: String?
    let image: String?
    let category: String?
    let startingFrom: String?
    let riskChoking: Bool?
    let allergenic: Bool?
    let richIn: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case category
        case startingFrom = "starting_from"
        case riskChoking = "risk_choking"
        case allergenic
        case richIn = "rich_in"
    }

    init(data: [String: Any]) {
        self.id = data["id"] as? String
        self.name = data["name"] as? String
        self.image = data["image"] as? String
        self.category = data["category"] as? String
        self.startingFrom = data["starting_from"] as? String
        self.riskChoking = data["risk_choking"] as? Bool
        self.allergenic = data["allergenic"] as? Bool
        self.richIn = data["rich_in"] as? [String]
    }

}
