//
//  String+Extensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 15.04.2023.
//

import Foundation

extension String {
    var capitalizedSentence: String {
        // 1
        let firstLetter = self.prefix(1).capitalized
        // 2
        let remainingLetters = self.dropFirst().lowercased()
        // 3
        return firstLetter + remainingLetters
    }
}
