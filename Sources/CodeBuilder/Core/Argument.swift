//
//  Argument.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 15.03.20.
//

import Foundation

/**
 A Fragment formatted as an argument
 */
public struct Argument: Fragment {

    /**
    Standard initializer.
       - parameters:
           - name: The name of the argument
           - type: The text representation of the function argument type
    */
    public init(name: String, type: String) {
        self.name = name
        self.type = type
    }

    // MARK: Stored Properties
    /**
     The name of the argument
     */
    public let name: String

    /**
     The text representation of the function argument type
     */
    public let type: String

    @inlinable
    public func asParameter(documentation: String) -> Parameter {
        Parameter(name: self.name, documentation: documentation)
    }

    /**
     Renders this Argument as a string.

     The String format is as follows:
     ```
     "\(self.name): \(self.type)"
     ```
     */
    @inlinable
    public func renderContent() -> String {
        return "\(self.name): \(self.type)"
    }
}
