//
//  CodeBuilder.swift
//  
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 01.03.20.
//

import Foundation

@_functionBuilder
public struct CodeBuilder {
    public static func buildBlock() -> [Fragment] {
        return []
    }

    public static func buildBlock(_ fragments: Fragment...) -> [Fragment] {
        return fragments
    }

    public static func buildBlock(_ fragment: Fragment) -> [Fragment] {
        return [fragment]
    }

    public static func buildExpression(_ fragment: Fragment) -> [Fragment] {
        return [fragment]
    }

    public static func buildIf(_ component: Fragment?) -> [Fragment] {
        guard let component = component else { return [] }
        return [component]
    }

    public static func buildEither(first: Fragment) -> [Fragment] {
        [first]
    }

    public static func buildEither(second: Fragment) -> [Fragment] {
        [second]
    }
}

/**
 Creates a SingleLineFragment out of a String
 - parameters:
    - statement: The string content of the SingleLineFragment
 - returns: SingleLineFragment
 */
@inlinable public func statement(_ statement: String) -> Fragment {
    SingleLineFragment(statement)
}

/// Adds a line break
///
@inlinable public func lineBreak() -> Fragment {
    SingleLineFragment("")
}

/// Ends scope
///
@inlinable public func end() -> Fragment {
    SingleLineFragment("}")
}
