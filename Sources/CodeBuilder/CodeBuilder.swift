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
 Builds a String with Fragments
 - parameters:
    - indent: Whitespace indentation used to render Swift code
    - builder: Creates Fragments that build the String representing Swift code.
 */
public func code(indent: String, @CodeBuilder _ builder: () -> [Fragment]) -> String {
    String(indent, builder: builder)
}

/**
Builds a String with a Fragment
- parameters:
   - indent: Whitespace indentation used to render Swift code
   - builder: Creates a single Fragment that builds the String representing Swift code.
*/
public func code(indent: String, @CodeBuilder _ builder: () -> Fragment) -> String {
    String(indent, builder: { [builder()] })
}

/**
 Create a CodeFragment formatted for documentation
 - parameters:
    - content            : The content of the documentation
    - format             : Determines whether or not the content will use single line or multiline documentaion notation
    - parameters         : The parameters documentation
    - returnValue        : The return value documentation
    - tag                : The tag link to this documentation
 - returns:
    CodeFragment formatted specifically as documentation
 - Tag: documentation
 */
public func documentation(
    _ content: String,
    format: Documentation.Format = .singleLine,
    parameters: [Parameter] = [],
    returnValue: String? = nil,
    tag: String? = nil
) -> Fragment {
    let prefix: String = format == .singleLine ? "/// " : ""
    let content: String = "\(prefix)\(content)"

    let parameters: [Fragment?] = !parameters.isEmpty
        ? parameters.reduce(into: [SingleLineFragment("- parameters:")]) { $0.append(SingleLineFragment($1.renderContent())) }
        : []

    let returnValue: Fragment? = returnValue != nil
        ? SingleLineFragment("- returns: \(returnValue!)")
        : nil

    let tag: Fragment? = tag != nil
        ? SingleLineFragment("- Tag: \(tag!)")
        : nil

    let fragments: [Fragment?] = parameters + [returnValue, tag]
    return Documentation(content, format: format, { fragments.compactMap { $0} })
}

/**
 Creates a SingleLineFragment out of a String
 - parameters:
    - statement: The string content of the SingleLineFragment
 - returns: SingleLineFragment
 */
public func statement(_ statement: String) -> Fragment {
    SingleLineFragment(statement)
}

/// Adds a line break
///
public func lineBreak() -> Fragment {
    SingleLineFragment("")
}

/// Ends scope
///
public func end() -> Fragment {
    SingleLineFragment("}")
}
