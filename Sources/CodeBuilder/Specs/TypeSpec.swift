//
//  TypeSpec.swift
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
public func typeSpec(_ name: String, access: Access = .internal, type: DataType, inheritingFrom parents: [String] = [], @CodeBuilder _ builder: () -> [Fragment]) -> Fragment {
    let access: String = access == .internal ? "" : "\(access.rawValue)"
    var content: String = "\(access)\(type.rawValue) \(name)"
    content += !parents.isEmpty
        ? ": " + parents.joined(separator: ", ")
        : ""
    content += " {\n"
    return GroupFragment(children: [MultiLineFragment(content, builder), lineBreak(), end()])
}

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
public func typeSpec(_ name: String, access: Access = .internal, type: DataType, inheritingFrom parents: [String] = [], @CodeBuilder _ builder: () -> Fragment) -> Fragment {
    typeSpec(name, access: access, type: type, inheritingFrom: parents, { [builder()] })
}
