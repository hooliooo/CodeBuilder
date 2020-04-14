//
//  Parameter.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 06.03.20.
//

import Foundation

/**
 Represents a parameter documentation in the proper format
 */
public struct Parameter: Fragment {

    /**
     Standard initializer.
        - parameters:
            - name         : The name of the parameter
            - documentation: The documentation that describes the parameter
     */
    public init(name: String, documentation: String) {
        self.name = name
        self.documentation = documentation
    }

    // MARK: Stored Properties

    /// The name of the parameter
    public let name: String

    /// The documentation that describes the parameter
    public let documentation: String

    // MARK: Methods
    @inlinable
    public func renderContent() -> String {
        return "   - \(self.name): \(self.documentation)"
    }
}
