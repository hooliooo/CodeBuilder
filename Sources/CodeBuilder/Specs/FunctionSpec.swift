//
//  FunctionSpec.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 15.03.20.
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
    throwsError: Bool = false,
    genericSignature: String? = nil,
    arguments: [Argument] = [],
    returnValue: String? = nil,
    @CodeBuilder _ builder: () -> CodeRepresentable
) -> CodeRepresentable {
    let access: String = access == .internal ? "" : "\(access.rawValue) "
    let type: String = isStatic ? "static " : ""
    let args: String = !arguments.isEmpty ? arguments.map { $0.renderContent() }.joined(separator: ", ") : ""
    let genericSignature: String = genericSignature != nil ? "<\(genericSignature!)>" : ""
    let throwsError: String = throwsError ? " throws " : " "
    let returnValue: String = returnValue != nil ? "\(throwsError)-> \(returnValue!) {" : "\(throwsError){"
    let functionSignature: String = "\(access)\(type)func \(name)\(genericSignature)(\(args))\(returnValue)"

    if functionSignature.count > 120, arguments.count > 1 {

        let fragments: [Fragment] = arguments
            .dropLast()
            .map { SingleLineFragment("\($0.renderContent()),") }

        let lastFragment: Fragment = SingleLineFragment(arguments.last!.renderContent())
        let children: Code = (fragments + [lastFragment]).asCode
        let first: MultiLineFragment = MultiLineFragment(
            "\(access)\(type)func \(name)\(genericSignature)(",
            { children }
        )
        let second: MultiLineFragment = MultiLineFragment(")\(returnValue)", builder)
        return GroupFragment(children: [first, second, end()])
    } else {
        return GroupFragment(children: [MultiLineFragment(functionSignature, builder), end()])
    }
}
