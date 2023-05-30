//
//  String+Extension.swift
//  weaning
//
//  Created by Yuri Cavallin on 25/2/23.
//

import Foundation
import UIKit

extension String {

    func htmlToAttributedString() -> NSMutableAttributedString? {
        let preparedTitle = self.replacingOccurrences(of: "\r\n", with: "<br/>").replacingOccurrences(of: "\n", with: "<br/>")

        guard let data = preparedTitle.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        let attributedString = try? NSAttributedString(data: data,
                                                       options: options,
                                                       documentAttributes: nil)

        guard let attributedHtmlString = attributedString else {
            return nil
        }

        let stringRange = attributedHtmlString.string.nsRange
        let mutableAttributedHtmlString = attributedHtmlString.mutable

        attributedHtmlString.enumerateAttribute(.font,
                                                in: stringRange,
                                                options: .longestEffectiveRangeNotRequired) { value, range, _ in
                                                    let replacementFont = UIFont.regularFontOf(size: 18)
                                                    mutableAttributedHtmlString.addAttribute(.font,
                                                                                             value: replacementFont,
                                                                                             range: range)
        }

        mutableAttributedHtmlString.addAttribute(.foregroundColor,
                                                 value: UIColor.textColor,
                                                 range: stringRange)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        mutableAttributedHtmlString.addAttribute(.paragraphStyle,
                                                 value: paragraphStyle,
                                                 range: stringRange)

        return mutableAttributedHtmlString
    }

    var nsRange: NSRange {
        let stringRange = startIndex..<endIndex
        return NSRange(stringRange, in: self)
    }

    func localized() -> String {
        NSLocalizedString(self, comment: self)
    }

}

extension NSAttributedString {

    var mutable: NSMutableAttributedString {
        return NSMutableAttributedString(attributedString: self)
    }

}
