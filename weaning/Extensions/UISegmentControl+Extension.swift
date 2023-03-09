//
//  UISegmentControl+Extension.swift
//  weaning
//
//  Created by Yuri Cavallin on 25/2/23.
//

import UIKit

extension UISegmentedControl {

    func replaceSegmentsWith(_ segments: [String]) {
        self.removeAllSegments()
        for segment in segments {
            self.insertSegment(withTitle: segment, at: self.numberOfSegments, animated: false)
        }
    }

}
