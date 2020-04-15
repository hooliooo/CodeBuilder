//
//  TypeSpecs.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 15.03.20.
//

import Foundation

/**
Creates a Fragment formatted specifically for defining a Swift type
- parameters:
   - name: The name of the type being defined
   - access: The access level of the type
   - type: Determines whether the type being defined is a class, enum or struct
   - parents: The parent class/protocols the type inherits or conforms to
   - builder: Fragments that represent the body of the type's definition
*/
@inlinable
public func typeSpec(
    _ name: String,
    access: Access = .internal,
    type: DataType,
    inheritingFrom parents: [String] = [],
    @CodeBuilder _ builder: () -> CodeRepresentable = { Code.fragments([]) }
) -> CodeRepresentable {
    let access: String = access == .internal ? "" : "\(access.rawValue) "
    var content: String = "\(access)\(type.rawValue) \(name)"
    content += !parents.isEmpty
        ? ": " + parents.joined(separator: ", ")
        : ""
    content += " {\n"
    return GroupFragment(fragments: [MultiLineFragment(content, builder), end()])
}

/**
 Creates a Fragment formatted specifically for defining a Swift class type
 - parameters:
     - name: The name of the class being defined
     - access: The access level of the class
     - parents: The parent class/protocols the class inherits or conforms to
     - builder: Fragments that represent the body of the class's definition
 */
@inlinable
public func classSpec(_ name: String, access: Access = .internal, inheritingFrom parents: [String] = [], @CodeBuilder _ builder: () -> CodeRepresentable) -> CodeRepresentable {
    typeSpec(name, access: access, type: DataType.class, inheritingFrom: parents, builder)
}

/**
Creates a Fragment formatted specifically for defining a Swift class type
- parameters:
    - name     : The name of the struct being defined
    - access   : The access level of the struct
    - protocols: The protocols the struct conforms to
    - body     : Fragments that represent the body of the struct's definition
*/
@inlinable
public func structSpec(_ name: String, access: Access = .internal, inheritingFrom protocols: [String] = [], @CodeBuilder _ body: () -> CodeRepresentable) -> CodeRepresentable {
    typeSpec(name, access: access, type: DataType.struct, inheritingFrom: protocols, body)
}

/**
Creates a Fragment formatted specifically for defining a Swift enum type with either normal enum cases, associated value cases, or both
- parameters:
    - access   : The access level of the enum
    - enumSpec : The enum specification
    - protocols: The protocols the enum conforms to
    - body     : Fragments that represent the body of the enum's definition. This should not contain cases.
*/
@inlinable
public func enumSpec(
    access: Access = .internal,
    enumSpec: Enum,
    inheritingFrom protocols: [String] = [],
    @CodeBuilder _ body: () -> CodeRepresentable = { Code.fragments([]) }
) -> CodeRepresentable {

    let access: String = access == .internal ? "" : "\(access.rawValue) "
    var content: String = "\(access)enum \(enumSpec.name)"
    content += !protocols.isEmpty
        ? ": " + protocols.joined(separator: ", ")
        : ""
    content += " {\n"

    let fragments: [Fragment] = enumSpec.cases.map { SingleLineFragment($0.renderContent()) }

    switch enumSpec.cases.isEmpty {
        case true:
            return GroupFragment(
                fragments: [
                    MultiLineFragment(content, body),
                    end()
                ]
            )
        case false:
            return GroupFragment(
                fragments: [
                    MultiLineFragment(
                        content,
                        {
                            Code.fragments(fragments)
                            lineBreak()
                            body()
                        }
                    ),
                    end()
                ]
            )
    }
}

/**
Creates a Fragment formatted specifically for defining a Swift raw value enum
- parameters:
    - access   : The access level of the enum
    - enumSpec : The RawValueEnum specification
    - protocols: The protocols the enum conforms to
    - body     : Fragments that represent the body of the enum's definition. This should not contain cases.
*/
@inlinable
public func rawValueEnumSpec<T>(
    access: Access = .internal,
    enumSpec: RawValueEnum<T>,
    inheritingFrom protocols: [String] = [],
    @CodeBuilder _ body: () -> CodeRepresentable = { Code.fragments([]) }
) -> CodeRepresentable {
    let access: String = access == .internal ? "" : "\(access.rawValue) "
    var content: String = "\(access)enum \(enumSpec.name): \(enumSpec.typeDeescription)"
    content += !protocols.isEmpty
        ? ", " + protocols.joined(separator: ", ")
        : ""
    content += " {\n"

    let fragments: [Fragment] = enumSpec.cases.map { SingleLineFragment($0.renderContent()) }

    switch enumSpec.cases.isEmpty {
        case true:
            return GroupFragment(
                fragments: [
                    MultiLineFragment(content, body),
                    end()
                ]
            )
        case false:
            return GroupFragment(
                fragments: [
                    MultiLineFragment(
                        content,
                        {
                            Code.fragments(fragments)
                            lineBreak()
                            body()
                        }
                    ),
                    end()
                ]
            )
    }
}
