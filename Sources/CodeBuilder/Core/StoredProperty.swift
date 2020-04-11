//
//  StoredProperty.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 01.03.20.
//

import Foundation

/**
 StoredProperty represents the code that defines a property of a Swift data structure
 */
public struct StoredProperty: Fragment {

    /**
     Access level of the property
     */
    public let access: Access

    /**
     Bool flag that determines if the property is a `let` or `var`
     */
    public let isMutable: Bool

    /**
     The property's name
     */
    public let name: String

    /**
     The property's type
     */
    public let type: String

    /**
     The property's default value
     */
    public let value: String?

    /**
     The SingleLineFragment as a String. It is the content appended with a newline.
     */
    @inlinable
    public func renderContent() -> String {
        var content: String = self.access == .internal ? "" : "\(self.access.rawValue) "
        content += self.isMutable ? "var" : "let"
        content += " \(self.name)"
        content += ": \(self.type)"

        if let value = self.value {
            content += " = \(value)"
        }

        return content + "\n"
    }

    /**
     Transforms this StoredProperty instance into an Argument instance
     */
    public var asArgument: Argument {
        Argument(name: self.name, type: self.type)
    }
}

/**
 The access level modifiers available in Swift expressed as an enum
 */
public enum Access: String {
    case `open`, `public`, `internal`, `fileprivate`, `private`
}
