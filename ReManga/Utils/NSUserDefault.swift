//
//  NSUserDefault.swift
//  ReManga
//
//  Created by Даниил Виноградов on 01.06.2023.
//

import MvvmFoundation
import RxRelay
import RxSwift

@propertyWrapper
struct NSUserDefault<Value: NSObject & NSCoding> {
    let key: String
    let disposeBag = DisposeBag()

    var wrappedValue: Value {
        get { projectedValue.value }
        set { projectedValue.accept(newValue) }
    }

    let projectedValue: BehaviorRelay<Value>

    init(_ key: String, _ defaultValue: Value)  {
        self.key = key
        projectedValue = .init(value: Self.value(for: key) ?? defaultValue)

        bind(in: disposeBag) {
            projectedValue.bind { [key] val in
                Self.setValue(val, for: key)
            }
        }
    }

    private static func value(for key: String) -> Value? {
        guard let data = UserDefaults.standard.data(forKey: key)
        else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: Value.self, from: data)
    }

    private static func setValue(_ value: Value, for key: String) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true)
            UserDefaults.standard.set(data, forKey: key)
        } catch {}
    }
}
