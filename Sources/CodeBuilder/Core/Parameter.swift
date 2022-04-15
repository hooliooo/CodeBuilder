//
//  CodeBuilder
//  Copyright (c) Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
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
    /**
     Renders this Parameter as a string.

     The String format is as follows:
     ```
     "   - \(self.name): \(self.documentation)"
     ```
     */
    @inlinable
    public func renderContent() -> String {
        return "   - \(self.name): \(self.documentation)"
    }
}
