//
//  CodeBuilder.swift
//  
//
//  Created by Julio Miguel Alorro on 01.03.20.
//

import Foundation

@_functionBuilder
public struct CodeBuilder {
    public static func buildBlock(_ fragments: CodeFragment...) -> [CodeFragment] {
        return fragments
    }

    public static func buildBlock(_ fragment: CodeFragment) -> [CodeFragment] {
        return [fragment]
    }

    public static func buildExpression(_ fragment: CodeFragment) -> [CodeFragment] {
        return [fragment]
    }

    public static func buildIf(_ component: CodeFragment?) -> [CodeFragment] {
        guard let component = component else { return [] }
        return [component]
    }

    public static func buildEither(first: CodeFragment) -> [CodeFragment] {
        [first]
    }

    public static func buildEither(second: CodeFragment) -> [CodeFragment] {
        [second]
    }
}

public func code(indent: String, @CodeBuilder _ builder: () -> [CodeFragment]) -> String {
    String(indent, builder: builder)
}

public func code(indent: String, @CodeBuilder _ builder: () -> CodeFragment) -> String {
    String(indent, builder: { [builder()] })
}

//public func code(indent: String, _ builder: @escaping () -> Void) -> String {
//    String(indent, builder: { [] })
//}

public func beginControlFlow(_ statement: String, @CodeBuilder _ builder: () -> [CodeFragment]) -> CodeFragment {
    MultiCodeFragment("\(statement) {", builder)
}

//public func beginControlFlow(_ statement: String, @CodeBuilder _ builder: () -> CodeFragment) -> CodeFragment {
//    MultiCodeFragment("\(statement) {", { [builder()] })
//}

public func elseControlFlow(@CodeBuilder _ builder: () -> [CodeFragment]) -> CodeFragment {
    MultiCodeFragment("} else {", builder)
}

public func elseControlFlow(@CodeBuilder _ builder: () -> CodeFragment) -> CodeFragment {
    MultiCodeFragment("} else {", { [builder()] })
}
/// Ends scope
///
public func end() -> CodeFragment {
    SingleCodeFragment("}")
}
/// Make sure to call [documentation](x-source-tag://documentation) at some point when overriding.
public func define(_ typeName: String, type: DataType, inheritingFrom parents: [String] = [], @CodeBuilder _ builder: () -> [CodeFragment]) -> CodeFragment {
    var content: String = type.rawValue + " \(typeName)"
    content = {
        switch parents.count {
            case 0: return content + " {"
            case 1: return content + ": \(String(describing: parents.first!))"
            default:
                let parentsExceptLast: ArraySlice<String> = parents.dropLast()
                content += parentsExceptLast.reduce(into: ": ", { $0 += $1 + ", " })
                content +=  parents.last!
                content += " {"
                return content + "\n"
        }
    }()

    return MultiCodeFragment(content, builder)
}

//public func define(_ typeName: String, type: DataType, inheritingFrom parents: [String] = [], @CodeBuilder _ builder: () -> CodeFragment) -> CodeFragment {
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
    format: ParameterDocumentation.Format = .singleLine,
    parameters: [ParameterDocumentation] = [],
    returnValue: String? = nil,
    tag: String? = nil
) -> CodeFragment {
    let prefix: String = format == .singleLine ? "/// " : ""
    let content: String = "\(prefix)\(content)"

    let parameterCodeFragments: [CodeFragment] = parameters.map { SingleCodeFragment($0.renderContent()) }

    let returnValue: CodeFragment? = returnValue != nil
        ? SingleCodeFragment("- returns: \(returnValue!)")
        : nil

    let tag: CodeFragment? = tag != nil
        ? SingleCodeFragment("- Tag: \(tag!)")
        : nil

    let fragment: SingleCodeFragment? = !parameters.isEmpty
        ? SingleCodeFragment("- parameters:")
        : nil

    let fragments: [CodeFragment?] = [fragment] + parameterCodeFragments + [returnValue, tag]
    return MultiCodeFragment(content, type: .documentation(format), { fragments.compactMap { $0} })
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
    @CodeBuilder _ builder: () -> [CodeFragment]
) -> CodeFragment {
    let type: String = isStatic ? " static " : " "
    let args: String = !arguments.isEmpty ? arguments.map { $0.content() }.joined(separator: ", ") : ""
    let returnValue: String = returnValue != nil ? " -> \(returnValue!) {" : " {"
    let functionSignature: String = "\(access.rawValue)\(type)func \(name)(\(args))\(returnValue)"
    return MultiCodeFragment(functionSignature, builder)
}

public func function(
    _ name: String,
    access: Access = .internal,
    isStatic: Bool = false,
    genericSignature: String? = nil,
    arguments: [FunctionArgument] = [],
    returnValue: String? = nil,
    @CodeBuilder _ builder: () -> CodeFragment
) -> CodeFragment {
    return function(
        name,
        access: access,
        isStatic: isStatic,
        genericSignature: genericSignature,
        arguments: arguments,
        returnValue: returnValue,
        { [builder()] }
    )
}

/**
 asdfasd
 - parameters:
    - statement: Something
 */
public func statement(_ statement: String) -> CodeFragment {
    SingleCodeFragment(statement)
}
