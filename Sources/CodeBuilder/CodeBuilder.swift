//
//  CodeBuilder.swift
//  
//  Copyright (c) Julio Miguel Alorro 2019
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

//public func code(indent: String, _ builder: @escaping () -> Void) -> String {
//    String(indent, builder: { [] })
//}

public func beginControlFlow(_ statement: String, @CodeBuilder _ builder: () -> [Fragment]) -> Fragment {
    MultiLineFragment("\(statement) {", builder)
}

//public func beginControlFlow(_ statement: String, @CodeBuilder _ builder: () -> Fragment) -> Fragment {
//    MultiLineFragment("\(statement) {", { [builder()] })
//}

public func elseControlFlow(@CodeBuilder _ builder: () -> [Fragment]) -> Fragment {
    MultiLineFragment("} else {", builder)
}

public func elseControlFlow(@CodeBuilder _ builder: () -> Fragment) -> Fragment {
    MultiLineFragment("} else {", { [builder()] })
}
/// Ends scope
///
public func end() -> Fragment {
    SingleLineFragment("}")
}
/// Make sure to call [documentation](x-source-tag://documentation) at some point when overriding.
public func define(_ typeName: String, type: DataType, inheritingFrom parents: [String] = [], @CodeBuilder _ builder: () -> [Fragment]) -> Fragment {
    var content: String = type.rawValue + " \(typeName)"
    content += !parents.isEmpty
        ? ": " + parents.joined(separator: ", ") + " {\n"
        : " {\n"
    return MultiLineFragment(content, builder)
}

//public func define(_ typeName: String, type: DataType, inheritingFrom parents: [String] = [], @CodeBuilder _ builder: () -> Fragment) -> Fragment {
//    define(typeName, type: type, inheritingFrom: parents, { [builder()] })
//}

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
    format: DocumentationFormat = .singleLine,
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
    return MultiLineFragment(content, type: .documentation(format), { fragments.compactMap { $0} })
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
    arguments: [FunctionArgument] = [],
    returnValue: String? = nil,
    @CodeBuilder _ builder: () -> [Fragment]
) -> Fragment {
    let type: String = isStatic ? " static " : " "
    let args: String = !arguments.isEmpty ? arguments.map { $0.renderContent() }.joined(separator: ", ") : ""
    let returnValue: String = returnValue != nil ? " -> \(returnValue!) {" : " {"
    let functionSignature: String = "\(access.rawValue)\(type)func \(name)(\(args))\(returnValue)"
    return MultiLineFragment(functionSignature, builder)
}

public func function(
    _ name: String,
    access: Access = .internal,
    isStatic: Bool = false,
    genericSignature: String? = nil,
    arguments: [FunctionArgument] = [],
    returnValue: String? = nil,
    @CodeBuilder _ builder: () -> Fragment
) -> Fragment {
    return function(
        name, access: access, isStatic: isStatic, genericSignature: genericSignature, arguments: arguments, returnValue: returnValue,{ [builder()] }
    )
}

/**
 asdfasd
 - parameters:
    - statement: Something
 */
public func statement(_ statement: String) -> Fragment {
    SingleLineFragment(statement)
}
