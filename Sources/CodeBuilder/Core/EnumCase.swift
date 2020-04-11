//
//  EnumCase.swift
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

public protocol MixableEnumCase: EnumCase {}

public struct NormalEnumCase: MixableEnumCase {

    public let name: String

    @inlinable
    public func renderContent() -> String {
        return "case \(self.name)"
    }

}

public struct RawValueEnumCase<V>: EnumCase {

    public let name: String

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

public struct AssociatedValueEnumCase: MixableEnumCase {

    public let name: String

    public let types: [String]

    @inlinable
    public func renderContent() -> String {
        let types: String = self.types.joined(separator: ", ")
        return "case \(self.name)(\(types))"
    }

}

public protocol EnumSpec {

    var name: String { get }

}

public struct RawValueEnum<T>: EnumSpec {

    public let name: String

    public let typeDeescription: String

    public let cases: [RawValueEnumCase<T>]

    @inlinable
    public init(name: String, cases: [RawValueEnumCase<T>]) {
        self.name = name
        self.typeDeescription = String(describing: T.self)
        self.cases = cases
    }

}

public struct Enum: EnumSpec {

    public let name: String

    public let cases: [MixableEnumCase]

}


