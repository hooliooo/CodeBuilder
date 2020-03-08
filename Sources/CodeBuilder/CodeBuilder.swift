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

public func code(indent: String, @CodeBuilder _ builder: () -> [Fragment]) -> String {
    String(indent, builder: builder)
}

public func code(indent: String, @CodeBuilder _ builder: () -> Fragment) -> String {
    String(indent, builder: { [builder()] })
}

public func beginControlFlow(_ statement: String, @CodeBuilder _ builder: () -> [Fragment]) -> Fragment {
    MultiLineFragment("\(statement) {", builder)
}

public func beginControlFlow(_ statement: String, @CodeBuilder _ builder: () -> Fragment) -> Fragment {
    MultiLineFragment("\(statement) {", { [builder()] })
}

public func elseIf(_ statement: String, @CodeBuilder _ builder: () -> [Fragment]) -> Fragment {
    let t = MultiLineFragment("} else if \(statement) {", builder)
    return t
}

public func elseIf(_ statement: String, @CodeBuilder _ builder: () -> Fragment) -> Fragment {
    MultiLineFragment("} else if \(statement) {", { [builder()] })
}

public func elseControlFlow(@CodeBuilder _ builder: () -> [Fragment]) -> Fragment {
    MultiLineFragment("} else {", builder)
}

public func elseControlFlow(@CodeBuilder _ builder: () -> Fragment) -> Fragment {
    MultiLineFragment("} else {", { [builder()] })
}

/// Make sure to call [documentation](x-source-tag://documentation) at some point when overriding.
public func define(_ typeName: String, type: DataType, inheritingFrom parents: [String] = [], @CodeBuilder _ builder: () -> [Fragment]) -> Fragment {
    var content: String = type.rawValue + " \(typeName)"
    content += !parents.isEmpty
        ? ": " + parents.joined(separator: ", ") + " {\n"
        : " {\n"
    return MultiLineFragment(content, builder)
}

public func define(_ typeName: String, type: DataType, inheritingFrom parents: [String] = [], @CodeBuilder _ builder: () -> Fragment) -> Fragment {
    define(typeName, type: type, inheritingFrom: parents, { [builder()] })
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
 asdfasd
 - parameters:
    - statement: Something
 */
public func function(
    _ name: String,
    access: Access = .internal,
    isStatic: Bool = false,
    genericSignature: String? = nil,
    arguments: [Function.Argument] = [],
    returnValue: String? = nil,
    @CodeBuilder _ builder: () -> [Fragment]
) -> Fragment {
    let access: String = access == .internal ? "" : "\(access.rawValue) "
    let type: String = isStatic ? "static " : ""
    let args: String = !arguments.isEmpty ? arguments.map { $0.renderContent() }.joined(separator: ", ") : ""
    let genericSignature: String = genericSignature != nil ? "<\(genericSignature!)>" : ""
    let returnValue: String = returnValue != nil ? " -> \(returnValue!) {" : " {"
    let functionSignature: String = "\(access)\(type)func \(name)\(genericSignature)(\(args))\(returnValue)"

    if functionSignature.count > 120, arguments.count > 1 {

        let fragments: [Fragment] = arguments
            .dropLast()
            .map { SingleLineFragment("\($0.renderContent()),") }

        let lastFragment: Fragment = SingleLineFragment(arguments.last!.renderContent())
        let children: [Fragment] = fragments + [lastFragment]
        let first: MultiLineFragment = MultiLineFragment(
            "\(access)\(type)func \(name)\(genericSignature)(",
            { children }
        )
        let second: MultiLineFragment = MultiLineFragment(")\(returnValue)", builder)
        return GroupFragment(children: [first, second])
    } else {
        return MultiLineFragment(functionSignature, builder)
    }
}

public func function(
    _ name: String,
    access: Access = .internal,
    isStatic: Bool = false,
    genericSignature: String? = nil,
    arguments: [Function.Argument] = [],
    returnValue: String? = nil,
    @CodeBuilder _ builder: () -> Fragment
) -> Fragment {
    return function(
        name, access: access, isStatic: isStatic, genericSignature: genericSignature, arguments: arguments, returnValue: returnValue,{ [builder()] }
    )
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
