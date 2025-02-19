//
//  String+Extensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 15.04.2023.
//

import Foundation
import UIKit

extension String {
    var capitalizedSentence: String {
        // 1
        let firstLetter = self.prefix(1).capitalized
        // 2
        let remainingLetters = self.dropFirst().lowercased()
        // 3
        return firstLetter + remainingLetters
    }

    func removeUTF8Encodings() -> String? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }

        guard let attributedString = try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        ) else {
            return nil
        }

        return attributedString.trimedCharactersInSet(charSet: .whitespacesAndNewlines).string
    }

    func htmlToAttributedString(of size: Int = 17, with textColor: UIColor = .label) -> NSMutableAttributedString? {
        let htmlTemplate = """
        <!doctype html>
        <html>
          <head>
            <style>
              body {
                font-family: -apple-system;
                font-size: \(size)px;
              }
            </style>
          </head>
          <body>
            \(self)
          </body>
        </html>
        """

        guard let data = htmlTemplate.data(using: .utf8) else {
            return nil
        }

        guard let attributedString = try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        ) else {
            return nil
        }

        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor
        ]

        attributedString.addAttributes(attrs, range: .init(location: 0, length: attributedString.length))

        return attributedString.trimedCharactersInSet(charSet: .whitespacesAndNewlines)
    }
}
