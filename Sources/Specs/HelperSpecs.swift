//
//  HelperSpecs.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 19.03.20.
//

import Foundation
import Core

/**
 Creates a SingleLineFragment out of a String
 - parameters:
    - statement: The string content of the SingleLineFragment
 - returns: SingleLineFragment
 */
@inlinable
public func statement(_ statement: String) -> Fragment {
    SingleLineFragment(statement)
}

/// Adds a line break
///
@inlinable
public func lineBreak() -> Fragment {
    SingleLineFragment("")
}

/// Ends scope
///
@inlinable
public func end() -> Fragment {
    SingleLineFragment("}")
}
