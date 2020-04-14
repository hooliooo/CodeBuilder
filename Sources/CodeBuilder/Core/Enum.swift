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

    /// The name of the enum case
    public let name: String

    @inlinable
    public func renderContent() -> String {
        return "case \(self.name)"
    }

}

/**
 A Fragment that is rendered as a raw value enum case
 */
public struct RawValueEnumCase<V>: EnumCase {

    /// The name of the enum case
    public let name: String

    /// The rawValue of the enum case
    public let value: V?

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

    /// The name of the enum case
    public let name: String

    /// The associated value data types of the enum case
    public let types: [String]

    @inlinable
    public func renderContent() -> String {
        let types: String = self.types.joined(separator: ", ")
        return "case \(self.name)(\(types))"
    }

}

/**
 Represents an raw value enum definition
 */
public struct RawValueEnum<T> {

    /// The name of the enum definition
    public let name: String

    /// The String representation of the raw value type of the enum
    public let typeDeescription: String

    /// The cases of the enum
    public let cases: [RawValueEnumCase<T>]

    @inlinable
    public init(name: String, cases: [RawValueEnumCase<T>]) {
        self.name = name
        self.typeDeescription = String(describing: T.self)
        self.cases = cases
    }

}

/**
Represents an enum definition
*/
public struct Enum {

    /// The name of the enum definition
    public let name: String

    /// The cases of the enum
    public let cases: [MixableEnumCase]

}
