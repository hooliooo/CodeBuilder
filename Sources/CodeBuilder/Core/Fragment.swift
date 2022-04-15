//
//  CodeBuilder
//  Copyright (c) Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import Foundation

/**
 Represents a line or block of Swift code
 */
public protocol Fragment: CodeRepresentable {

    /**
     Generates a String representation of the Swift code represented by this Fragment
     */
    @inlinable
    func renderContent() -> String

}

public extension Fragment {

    @inlinable
    var asCode: Code {
        .fragment(self)
    }

}
