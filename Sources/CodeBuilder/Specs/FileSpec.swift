//
//  FileSpec.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 15.03.20.
//

import Foundation

/**
 Creates a File that represents the Swift code built from the Fragments.
 - parameters:
    - fileName: The name of the Swift file to be created
    - indent  : Whitespace indentation used to render Swift code
    - builder : Creates Fragments that build the String representing Swift code.
 */
@inlinable
public func fileSpec(fileName: String, indent: String, @CodeBuilder _ builder: () -> CodeRepresentable) -> File {
    File(name: fileName, indent: indent, body: builder)
}

