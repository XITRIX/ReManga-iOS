//
//  UserDetault.swift
//  ReManga
//
//  Created by Даниил Виноградов on 10.05.2023.
//

import MvvmFoundation
import RxRelay
import RxSwift

@propertyWrapper
struct UserDefault<Value: Codable> {
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
        return try? JSONDecoder().decode(Value.self, from: data)
    }

    private static func setValue(_ value: Value, for key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            UserDefaults.standard.set(data, forKey: key)
        } catch {}
    }
}
