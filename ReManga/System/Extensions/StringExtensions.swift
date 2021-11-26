//
//  StringExtensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import UIKit

extension NSAttributedString {

    /** Will Trim space and new line from start and end of the text */
    public func trimWhitespacesAndNewlines() -> NSAttributedString {
        let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
        let startRange = string.utf16.description.rangeOfCharacter(from: invertedSet)
        let endRange = string.utf16.description.rangeOfCharacter(from: invertedSet, options: .backwards)
        guard let startLocation = startRange?.upperBound, let endLocation = endRange?.lowerBound else {
            return NSAttributedString(string: string)
        }

        let location = string.utf16.distance(from: string.startIndex, to: startLocation) - 1
        let length = string.utf16.distance(from: startLocation, to: endLocation) + 2
        let range = NSRange(location: location, length: length)
        return attributedSubstring(from: range)
    }

}

extension String {
    func htmlAttributedString(size: CGFloat = 17) -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }
        guard let html = try? NSMutableAttributedString(
                data: data,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil) else {
            return nil
        }

        let range = NSRange(location: 0, length: html.string.count)
        html.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: size), range: range)
        html.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.label, range: range)
        let res = html.trimWhitespacesAndNewlines()
        return res
    }

    func withBaseUrl() -> URL? {
        URL(string: ReClient.baseUrl + self)
    }
}
