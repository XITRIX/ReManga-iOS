//
//  CGPoint+Extensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 20.04.2023.
//

import Foundation

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
