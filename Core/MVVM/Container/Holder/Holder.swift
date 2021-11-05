//
//  Holder.swift
//  DemoMVVM
//
//  Created by Даниил Виноградов on 02.11.2021.
//

import Foundation

protocol HolderProtocol {
    var getter: Any { get }
}

class ResolverHolder: HolderProtocol {
    let factory: ()->Any
    var getter: Any {
        factory()
    }

    init(factory: @escaping ()->Any) {
        self.factory = factory
    }
}

class SingletonHolder: HolderProtocol {
    var factory: ()->Any
    lazy var instance: Any = factory()
    var getter: Any {
        instance
    }

    init(factory: @escaping ()->Any) {
        self.factory = factory
    }

    init(instance: Any) {
        self.factory = {}
        self.instance = instance
    }
}
