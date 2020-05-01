//
//  Enum.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 4/11/20.
//

import Foundation

/**
 A Fragment that is formatted as an enum case
 */
public protocol EnumCase: Fragment {
    var name: String { get }
}

/**
 A protocol adopted by NormalEnumCase and AssociatedValueEnumCase to ensure type safety
 */
public protocol MixableEnumCase: EnumCase {}

/**
 A Fragment that is rendered as a normal enum case
 */
public struct NormalEnumCase: MixableEnumCase {

    /**
     Initializer
     - parameters:
        - name: The name of the case
     */
    @inlinable
    public init(name: String) {
        self.name = name
    }


    /// The name of the enum case
    public let name: String

    /**
     Renders this NormalEnumCase as a string.

     The String format is as follows:
     ```
     "case \(self.name)"
     ```
     */
    @inlinable
    public func renderContent() -> String {
        return "case \(self.name)"
    }

}

/**
 A Fragment that is rendered as a raw value enum case
 */
public struct RawValueEnumCase<V>: EnumCase {

    /**
     Initializer
     - parameters:
        - name : The name of the case
        - value: The value of the case
     */
    @inlinable
    public init(name: String, value: V?) {
        self.name = name
        self.value = value
    }

    /// The name of the enum case
    public let name: String

    /// The rawValue of the enum case
    public let value: V?

    /**
     Renders this RawValueEnumCase as a string.

     The String format is as follows:
     when value is not nil:
     ```
     "case \(self.name) = \(value)"
     ```

     when value is nil:
     ```
     "case \(self.name)"
     ```
     */
    @inlinable
    public func renderContent() -> String {
        if let value = self.value {
            return "case \(self.name) = \(value)"
        } else {
            return "case \(self.name)"
        }
    }

}

/**
 A Fragment that is rendered as an enum case with an associated value
 */
public struct AssociatedValueEnumCase: MixableEnumCase {

    /**
     Initializer
     - parameters:
        - name : The name of the case
        - types: The associated values of the case
     */
    @inlinable
    public init(name: String, types: [String]) {
        self.name = name
        self.types = types
    }

    /// The name of the enum case
    public let name: String

    /// The associated value data types of the enum case
    public let types: [String]

    /**
     Renders this AssociatedValueEnumCase as a string.

     The String format is as follows:
     ```
     "case \(self.name) = \(types)" // where types is a comma separated String
     ```
     */
    @inlinable
    public func renderContent() -> String {
        let types: String = self.types.joined(separator: ", ")
        return "case \(self.name)(\(types))"
    }

}

/**
 Represents a Swift raw value enum definition
 */
public struct RawValueEnum<T> {

    /**
     Creates a RawValueEnum instance which represents a Swift raw value enum definition
     - parameters:
        - name : The name of this raw value enum
        - cases: The cases of this raw value enum
     */
    @inlinable
    public init(name: String, cases: [RawValueEnumCase<T>]) {
        self.name = name
        self.typeDeescription = String(describing: T.self)
        self.cases = cases
    }

    /// The name of the enum definition
    public let name: String

    /// The String representation of the raw value type of the enum
    public let typeDeescription: String

    /// The cases of the enum
    public let cases: [RawValueEnumCase<T>]

}

/**
Represents an enum definition
*/
public struct Enum {

    /**
     Initializer
     - parameters:
        - name : The name of the enum
        - cases: The cases of the enum
     */
    @inlinable
    public init(name: String, cases: [MixableEnumCase]) {
        self.name = name
        self.cases = cases
    }

    /// The name of the enum definition
    public let name: String

    /// The cases of the enum
    public let cases: [MixableEnumCase]

}
