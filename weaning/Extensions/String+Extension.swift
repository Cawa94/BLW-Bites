//
//  String+Extension.swift
//  weaning
//
//  Created by Yuri Cavallin on 25/2/23.
//

import Foundation
import UIKit

extension String {

    func htmlToAttributedString(fontSize: CGFloat = 18) -> NSMutableAttributedString? {
        let preparedTitle = self.replacingOccurrences(of: "\r\n", with: "<br/>").replacingOccurrences(of: "\n", with: "<br/>")

        guard let data = preparedTitle.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil)

        guard let attributedHtmlString = attributedString else {
            return nil
        }

        let stringRange = attributedHtmlString.string.nsRange
        var mutableAttributedHtmlString = attributedHtmlString.mutable

        attributedHtmlString.enumerateAttribute(.font,
                                                in: stringRange,
                                                options: .longestEffectiveRangeNotRequired) { value, range, _ in
                                                    let replacementFont = UIFont.regularFontOf(size: fontSize)
                                                    mutableAttributedHtmlString.addAttribute(.font,
                                                                                             value: replacementFont,
                                                                                             range: range)
        }

        mutableAttributedHtmlString.addAttribute(.foregroundColor,
                                                 value: UIColor.textColor,
                                                 range: stringRange)

        mutableAttributedHtmlString = replaceBoldParts(originalString: self, mutableString: mutableAttributedHtmlString, fontSize: fontSize)
        mutableAttributedHtmlString = replaceUnderlinedParts(originalString: self, mutableString: mutableAttributedHtmlString, fontSize: fontSize)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        mutableAttributedHtmlString.addAttribute(.paragraphStyle,
                                                 value: paragraphStyle,
                                                 range: stringRange)

        return mutableAttributedHtmlString
    }

    func replaceBoldParts(originalString: String, mutableString: NSMutableAttributedString, fontSize: CGFloat) -> NSMutableAttributedString {
        let updatedString = mutableString
        for index in originalString.indices(of: "<b>") {
            let boldString = originalString.suffix(from: index).asString.slice(from: "<b>", toString: "</b>")
            guard var boldBlock = boldString
                else { break }
            
            boldBlock = boldBlock.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")

            let boldAttribute: [NSAttributedString.Key : Any] = [
                .font : UIFont.extraBoldFontOf(size: fontSize),
                .foregroundColor: UIColor.mainColor
            ]

            if let range = updatedString.string.range(of: boldBlock) {
                updatedString.addAttributes(boldAttribute, range: NSRange(range, in: updatedString.string))
            }
        }

        return updatedString
    }

    func replaceUnderlinedParts(originalString: String, mutableString: NSMutableAttributedString, fontSize: CGFloat) -> NSMutableAttributedString {
        let updatedString = mutableString
        for index in originalString.indices(of: "<u>") {
            let boldString = originalString.suffix(from: index).asString.slice(from: "<u>", toString: "</u>")
            guard var boldBlock = boldString
                else { break }
            
            boldBlock = boldBlock.replacingOccurrences(of: "<u>", with: "").replacingOccurrences(of: "</u>", with: "")

            let boldAttribute: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font: UIFont.regularFontOf(size: fontSize),
                NSAttributedString.Key.foregroundColor: UIColor.textColor,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
            ]

            if let range = updatedString.string.range(of: boldBlock) {
                updatedString.addAttributes(boldAttribute, range: NSRange(range, in: updatedString.string))
            }
        }

        return updatedString
    }

    var nsRange: NSRange {
        let stringRange = startIndex..<endIndex
        return NSRange(stringRange, in: self)
    }

    func localized() -> String {
        NSLocalizedString(self, comment: self)
    }

    func indices(of string: String, options: String.CompareOptions = .literal) -> [Index] {
        var indices: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                indices.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return indices
    }

    func slice(from: String, toString: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: toString, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }

}

extension NSAttributedString {

    var mutable: NSMutableAttributedString {
        return NSMutableAttributedString(attributedString: self)
    }

}

extension Substring {

    var asString: String {
        return String(self)
    }

}
