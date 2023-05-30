//
//  Array+Algorythms.swift
//  ReManga
//
//  Created by Даниил Виноградов on 30.05.2023.
//

import Foundation

extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}
