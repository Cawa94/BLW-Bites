//
//  DefaultConstants.swift
//  weaning
//
//  Created by Yuri Cavallin on 18/2/23.
//

import Foundation

extension CGFloat {

    static let defaultCornerRadius: CGFloat = 15
    static let smallCornerRadius: CGFloat = .defaultCornerRadius/2
    static let bottomSpace: CGFloat = 50
    static let foodCellsSpacePercentage: CGFloat = 0.82 // how much space 2 foods cells take of the screen width
    static let recipeCellsSpacePercentage: CGFloat = 0.87 // how much space 2 recipes cells take of the screen width
    static let homepageCellsSpacePercentage: CGFloat = 0.75 // how much 2 cells take of the homepage screen full width
    static let foodImagesSpacePercentage: CGFloat = 0.82 // how much 2 pictures take of the screen width

}

extension Int {

    static let paginationSize: Int = 12
    static let menuFreeDays: Int = 10

}
