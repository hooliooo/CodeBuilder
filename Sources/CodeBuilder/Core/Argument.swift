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

    // MARK: Stored Properties

    /**
     Name of the argument
     */
    public let name: String

    /**
     A text representation of the function argument type
     */
    public let type: String

    @inlinable
    public func asParameter(documentation: String) -> Parameter {
        Parameter(name: self.name, documentation: documentation)
    }

    @inlinable
    public func renderContent() -> String {
        return "\(self.name): \(self.type)"
    }
}
