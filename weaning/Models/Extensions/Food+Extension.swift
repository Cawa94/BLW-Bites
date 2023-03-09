//
//  Food+Extension.swift
//  weaning
//
//  Created by Yuri Cavallin on 25/2/23.
//

import Foundation

extension Food {

    var hasAgeDictionary: Bool {
        ageDictionary != nil
    }

    var hasInfosDictionary: Bool {
        infosDictionary != nil
    }

    var ageSegments: [AgeSegment] {
        var segments: [AgeSegment] = []
        if let first = ageDictionary?.first {
            segments.append(first)
        }
        if let second = ageDictionary?.second {
            segments.append(second)
        }
        if let third = ageDictionary?.third {
            segments.append(third)
        }
        if let fourth = ageDictionary?.fourth {
            segments.append(fourth)
        }
        return segments
    }

    var infoSections: [InfoSection] {
        var infos: [InfoSection] = []
        if let first = infosDictionary?.first {
            infos.append(first)
        }
        if let second = infosDictionary?.second {
            infos.append(second)
        }
        if let third = infosDictionary?.third {
            infos.append(third)
        }
        if let fourth = infosDictionary?.fourth {
            infos.append(fourth)
        }
        if let fifth = infosDictionary?.fifth {
            infos.append(fifth)
        }
        if let sixth = infosDictionary?.sixth {
            infos.append(sixth)
        }
        if let seventh = infosDictionary?.seventh {
            infos.append(seventh)
        }
        return infos
    }

}
