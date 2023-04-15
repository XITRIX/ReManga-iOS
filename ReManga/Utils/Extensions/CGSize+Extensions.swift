//
//  CGSize+Extensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 15.04.2023.
//

import Foundation
import CoreGraphics

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}
