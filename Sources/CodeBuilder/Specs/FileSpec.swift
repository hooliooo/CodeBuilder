//
//  CodeBuilder
//  Copyright (c) Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import Foundation

/**
 Creates a File that represents the Swift code built from the Fragments.
 - parameters:
    - fileName: The name of the Swift file to be created
    - indent  : Whitespace indentation used to render Swift code
    - builder : Creates Fragments that build the String representing Swift code.
 - returns: A File instance
 */
@inlinable
public func fileSpec(fileName: String, indent: String, @CodeBuilder _ builder: () -> CodeRepresentable) -> File {
    File(name: fileName, indent: indent, body: builder)
}
