//
//  KeyChainValueTest.swift
//  
//
//  Created by Juraj Macák on 18/11/2022.
//

import XCTest
@testable import KeychainSwift

private struct CodableObject: Codable, Equatable {

    let int: Int
    let string: String
    let boolean: Bool
}

private enum Key {
    static let stringValueKey = "string_value_key"
    static let codableObjectKey = "codable_object_key"
}

// MARK: - Setup

class KeyChainValueTest: XCTestCase {

    @KeychainValue(Key.stringValueKey, defaultValue: nil)
    private var stringValue: String?

    @KeychainValue(Key.codableObjectKey, defaultValue: nil)
    private var codableObject: CodableObject?

    private var keychainSwift: KeychainSwift!

    override func tearDown() {
        super.tearDown()

        stringValue = nil
        codableObject = nil
    }
}

// MARK: - Tests

extension KeyChainValueTest {

    func testKeyChainValue_defaultValueShouldBeNil() {
        // Assert
        XCTAssertNil(stringValue)
        XCTAssertNil(codableObject)
    }

    func testKeyChainValue_shouldStoreAndRetrievePrimitiveValue() {
        // Arrange
        let string = "Lorem Ipsum"
        // Act
        stringValue = string
        // Assert
        XCTAssertEqual(stringValue, string)
    }

    func testKeyChainValue_shouldStoreAndRetrieveCodableObject() {
        // Arrange
        let object = CodableObject(int: 1, string: "Lorem Ipsum", boolean: true)
        // Act
        codableObject = object
        // Assert
        XCTAssertEqual(codableObject, object)
    }
}
