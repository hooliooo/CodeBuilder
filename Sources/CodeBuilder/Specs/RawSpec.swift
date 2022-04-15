//
//  CodeBuilder
//  Copyright (c) Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import Foundation

/**
 Transforms the String into SingleLineFragments and wraps the array in a Code.fragments enum case.

 The content is separated by a newline, removes trailing whitespace and transformed into an array of SingleFragments

 - parameter content: A String that represents Swift code.
 - returns: A Code.fragments instance as CodeRepresentable
 */
@inlinable
public func rawSpec(_ content: String) -> CodeRepresentable {
    return content
        .components(separatedBy: "\n")
        .lazy
        .map { $0.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression) }
        .map { SingleLineFragment($0) }
        .asCode
}
