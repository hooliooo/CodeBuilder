//
//  CodeBuilder
//  Copyright (c) Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
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

 - returns:A GroupFragment typed as a CodeRepresentable
 */
@inlinable
public func typeSpec(
    _ name: String,
    access: Access = .internal,
    type: DataType,
    inheritingFrom parents: [String] = [],
    @CodeBuilder _ builder: () -> CodeRepresentable = { Code.none }
) -> CodeRepresentable {
    let access: String = access == .internal ? "" : "\(access.rawValue) "
    var content: String = "\(access)\(type.rawValue) \(name)"
    content += !parents.isEmpty
        ? ": " + parents.joined(separator: ", ")
        : ""
    content += " {\n"
    return GroupFragment(children: [MultiLineFragment(content, builder), end()])
}

/**
 Creates a Fragment formatted specifically for defining a Swift class type
 - parameters:
     - name: The name of the class being defined
     - access: The access level of the class
     - parents: The parent class/protocols the class inherits or conforms to
     - builder: Fragments that represent the body of the class's definition

 - returns:A GroupFragment typed as a CodeRepresentable
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

 - returns:A GroupFragment typed as a CodeRepresentable
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

 - returns:A GroupFragment typed as a CodeRepresentable
 */
@inlinable
public func enumSpec(
    access: Access = .internal,
    enumSpec: Enum,
    inheritingFrom protocols: [String] = [],
    @CodeBuilder _ body: () -> CodeRepresentable = { Code.none }
) -> CodeRepresentable {

    let access: String = access == .internal ? "" : "\(access.rawValue) "
    var content: String = "\(access)enum \(enumSpec.name)"
    content += !protocols.isEmpty
        ? ": " + protocols.joined(separator: ", ")
        : ""
    content += " {\n"

    let fragments: [CodeRepresentable] = enumSpec.cases.map { SingleLineFragment($0.renderContent()) }
    return GroupFragment {
        MultiLineFragment(content) {
            if enumSpec.cases.isEmpty {
                body()
            } else {
                fragments
                lineBreak()
                body()
            }
        }
        end()
    }

//    return GroupFragment(
//        children: [
//            MultiLineFragment(content) {
//                if enumSpec.cases.isEmpty {
//                    body()
//                } else {
//                    fragments
//                    lineBreak()
//                    body()
//                }
//            },
//            end()
//        ]
//    )
}

/**
 Creates a Fragment formatted specifically for defining a Swift raw value enum
 - parameters:
    - access   : The access level of the enum
    - enumSpec : The RawValueEnum specification
    - protocols: The protocols the enum conforms to
    - body     : Fragments that represent the body of the enum's definition. This should not contain cases.

 - returns:A GroupFragment typed as a CodeRepresentable
 */
@inlinable
public func rawValueEnumSpec<T>(
    access: Access = .internal,
    enumSpec: RawValueEnum<T>,
    inheritingFrom protocols: [String] = [],
    @CodeBuilder _ body: () -> CodeRepresentable = { Code.none }
) -> CodeRepresentable {
    let access: String = access == .internal ? "" : "\(access.rawValue) "
    var content: String = "\(access)enum \(enumSpec.name): \(enumSpec.typeDeescription)"
    content += !protocols.isEmpty
        ? ", " + protocols.joined(separator: ", ")
        : ""
    content += " {"

    var fragments: [CodeRepresentable] = enumSpec.cases.map { SingleLineFragment($0.renderContent()) }
    let bodyCode: CodeRepresentable = body()

    let bodyIsNotEmpty: Bool = !bodyCode.asCode.fragments.isEmpty

    if bodyIsNotEmpty {
        fragments.append(contentsOf: [lineBreak(), bodyCode])
    }

    return GroupFragment(
        children: [
            MultiLineFragment(content) {
                if fragments.isEmpty {
                    lineBreak()
                } else {
                    fragments
                }
            },
            end()
        ]
    )
}
