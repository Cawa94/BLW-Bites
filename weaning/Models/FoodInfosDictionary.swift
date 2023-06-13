//
//  FoodInfosDictionary.swift
//  weaning
//
//  Created by Yuri Cavallin on 25/2/23.
//

import Foundation

public struct FoodInfosDictionary: Codable {

    let first: InfoSection?
    let second: InfoSection?
    let third: InfoSection?
    let fourth: InfoSection?
    let fifth: InfoSection?
    let sixth: InfoSection?
    let seventh: InfoSection?

    enum CodingKeys: String, CodingKey {
        case first
        case second
        case third
        case fourth
        case fifth
        case sixth
        case seventh
    }

    init(data: [String: Any]) {
        self.first = data["first"] as? InfoSection
        self.second = data["second"] as? InfoSection
        self.third = data["third"] as? InfoSection
        self.fourth = data["fourth"] as? InfoSection
        self.fifth = data["fifth"] as? InfoSection
        self.sixth = data["sixth"] as? InfoSection
        self.seventh = data["seventh"] as? InfoSection
    }

    init(first: InfoSection?,
         second: InfoSection?,
         third: InfoSection?,
         fourth: InfoSection?,
         fifth: InfoSection?,
         sixth: InfoSection?,
         seventh: InfoSection?) {
        self.first = first
        self.second = second
        self.third = third
        self.fourth = fourth
        self.fifth = fifth
        self.sixth = sixth
        self.seventh = seventh
    }

}
