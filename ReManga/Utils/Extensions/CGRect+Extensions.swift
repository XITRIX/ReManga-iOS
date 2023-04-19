//
//  CGRect+Extensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 20.04.2023.
//

import Foundation

extension CGRect {
    var center: CGPoint {
        .init(x: midX, y: midY)
    }
}
