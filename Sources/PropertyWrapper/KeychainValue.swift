//
//  KeychainValue.swift
//  
//
//  Created by Juraj Macák on 18/11/2022.
//

import Combine
import Foundation

@propertyWrapper
public final class KeychainValue<T: Codable> {

    struct Wrapper: Codable {
        let value: T
    }

    private let listDecoder = PropertyListDecoder()
    private let listEncoder = PropertyListEncoder()
    private let defaultValue: T
    private let key: String

    private lazy var keychainSwift: KeychainSwift = { KeychainSwift() }()

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get {
            guard let data = keychainSwift.getData(key) else {
                return defaultValue
            }

            return decode(data: data)
        }

        set(newValue) {
            let wrapper = Wrapper(value: newValue)

            guard let encodedData = encode(wrapper: wrapper) else { return }
            keychainSwift.set(encodedData, forKey: key)
        }
    }
}

// MARK: - Private

extension KeychainValue {

    private func decode(data: Data) -> T {
        (try? listDecoder.decode(Wrapper.self, from: data))?.value ?? defaultValue
    }

    private func encode(wrapper: Wrapper) -> Data? {
        try? listEncoder.encode(wrapper)
    }
}
