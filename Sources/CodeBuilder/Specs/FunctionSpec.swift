//
//  CodeBuilder
//  Copyright (c) Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import Foundation

/**
 Creates a Fragment formatted specifically for Swift functions
 - parameters:
    - name: The name of the function
    - access: The access level of the function
    - isStatic: Bool flag that determines whether or not the function is a static method
    - throwsError: Bool flag that determines whether or not the function throws
    - genericSignature: The generic signature of the function
    - arguments: The arguments of the function
    - returnValue: The return value of the function
    - builder: Fragments that represent the body of the function
 - returns: A GroupFragment typed as a CodeRepresentable
 */
@inlinable
public func functionSpec(
    _ name: String,
    access: Access = .internal,
    isStatic: Bool = false,
    keywords: Set<FunctionKeyword> = [],
    genericSignature: String? = nil,
    arguments: [Argument] = [],
    returnValue: String? = nil,
    @CodeBuilder _ builder: () -> CodeRepresentable
) -> CodeRepresentable {
    let access: String = access == .internal ? "" : "\(access.rawValue) "
    let type: String = isStatic ? "static " : ""
    let args: String = !arguments.isEmpty ? arguments.map { $0.renderContent() }.joined(separator: ", ") : ""

    let genericSignature: String = {
        guard let signature = genericSignature else { return "" }
        return "<\(signature)>"
    }()

    let doesNotContainBoth: Bool = (keywords.contains(FunctionKeyword.throwing(ThrowKeyword.throws)) &&
        keywords.contains(FunctionKeyword.throwing(ThrowKeyword.rethrows))) == false
    guard doesNotContainBoth else { return Code.none }

    let keywordString = keywords
        .sorted(by: <)
        .reduce(into: " ") { (currentResult: inout String, keyword: FunctionKeyword) -> Void in
          switch keyword {
              case .async:
                  currentResult += "async "
              case .throwing(let throwKeyword):
                  currentResult += "\(throwKeyword.rawValue) "
          }
        }

    let returnValue: String = {
        guard let returnValue = returnValue else { return "\(keywordString){" }
        return "\(keywordString)-> \(returnValue) {"
    }()

    let functionSignature: String = "\(access)\(type)func \(name)\(genericSignature)(\(args))\(returnValue)"

    if functionSignature.count > 120, arguments.count > 1, let lastArgument = arguments.last {

        let fragments: [Fragment] = arguments
            .dropLast()
            .map { SingleLineFragment("\($0.renderContent()),") }

        let lastFragment: Fragment = SingleLineFragment(lastArgument.renderContent())
        let children: Code = (fragments + [lastFragment]).asCode
        let first: MultiLineFragment = MultiLineFragment(
            "\(access)\(type)func \(name)\(genericSignature)(", { children }
        )
        let second: MultiLineFragment = MultiLineFragment(")\(returnValue)", builder)
        return GroupFragment(children: [first, second, end()])
    } else {
        return GroupFragment(children: [MultiLineFragment(functionSignature, builder), end()])
    }
}

public enum FunctionSpecError: Error {
    case invalidFunction
}
