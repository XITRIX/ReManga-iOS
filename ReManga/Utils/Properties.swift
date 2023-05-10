//
//  Properties.swift
//  ReManga
//
//  Created by Даниил Виноградов on 10.05.2023.
//

import MvvmFoundation

class Properties {
    static let shared = Properties()

    @UserDefault("backendKey", .remanga) var backendKey: ContainerKey.Backend

    private init() {}
}
