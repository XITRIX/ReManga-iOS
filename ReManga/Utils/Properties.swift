//
//  Properties.swift
//  ReManga
//
//  Created by Даниил Виноградов on 10.05.2023.
//

import MvvmFoundation
import UIKit

class Properties {
    static let shared = Properties()

    @UserDefault("backendKey", .remanga) var backendKey: ContainerKey.Backend
    @NSUserDefault("tintColor", .systemBlue) var tintColor: UIColor

    private init() {}
}
