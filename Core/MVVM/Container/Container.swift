//
//  Container.swift
//  DemoMVVM
//
//  Created by Даниил Виноградов on 01.11.2021.
//

import Foundation

class Container {
    private var map = [String: HolderProtocol]()

    // MARK: - Register
    func register<T: Any>(type: T.Type, factory: @escaping () -> T) {
        map[String(describing: type)] = ResolverHolder(factory: factory)
    }

    func register<T: Any>(factory: @escaping () -> T) {
        map[String(describing: T.self)] = ResolverHolder(factory: factory)
    }

    // MARK: - Singleton
    func registerSingleton<T: Any>(type: T.Type, factory: @escaping () -> T) {
        map[String(describing: type)] = SingletonHolder(factory: factory)
    }

    func registerSingleton<T: Any>(factory: @escaping () -> T) {
        map[String(describing: T.self)] = SingletonHolder(factory: factory)
    }

    // MARK: - Resolve
    func resolve<T: Any>(type: T.Type) -> T {
        if let obj = map[String(describing: type)]?.getter as? T {
            return obj
        }
        fatalError("\(T.self) is not registered")
    }

    func resolve<T: Any>() -> T {
        if let obj = map[String(describing: T.self)]?.getter as? T {
            return obj
        }
        fatalError("\(T.self) is not registered")
    }
}
