//
//  FileSpec.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 15.03.20.
//

import Foundation

/**
 Builds a String that represents a file of generated Swift code using Fragments to build the file's content
 - parameters:
    - indent: Whitespace indentation used to render Swift code
    - builder: Creates Fragments that build the String representing Swift code.
 */
public func fileSpec(indent: String, @CodeBuilder _ builder: () -> [Fragment]) -> String {
    String(indent, builder: builder)
}

/**
Builds a String that represents a file of generated Swift code using Fragments to build the file's content
- parameters:
   - indent: Whitespace indentation used to render Swift code
   - builder: Creates a single Fragment that builds the String representing Swift code.
*/
public func fileSpec(indent: String, @CodeBuilder _ builder: () -> Fragment) -> String {
    String(indent, builder: { [builder()] })
}
