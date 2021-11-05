//
//  StringExtensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import UIKit

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
        return html
    }

    func withBaseUrl() -> URL? {
        URL(string: ReClient.baseUrl + self)
    }
}
