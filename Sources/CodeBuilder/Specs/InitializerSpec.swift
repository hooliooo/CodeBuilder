//
//  CodeBuilder
//  Copyright (c) Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import Foundation

/**
 Creates a Fragment formatted specifically as an initializer.
 - parameters:
    - access       : The access level of the initializer
    - documentation: The documentation of the initializer
    - arguments    : The arguments of the initializer
    - throwsError : Bool flag indicating if the initializer throws or not
    - body         : The body of the initializer

 - returns: A GroupFragment typed as a CodeRepresentable
 */
@inlinable
public func initializerSpec(
    access: Access = .internal,
    documentation: Documentation? = nil,
    arguments: [Argument],
    throwsError: Bool,
    @CodeBuilder _ body: () -> CodeRepresentable
) -> CodeRepresentable {
    let access: String = access == .internal ? "" : "\(access.rawValue) "
    let args: String = !arguments.isEmpty ? arguments.map { $0.renderContent() }.joined(separator: ", ") : ""
    let content: String = "\(access)init(\(args))\(throwsError ? " throws " : " "){"
    let initializerFragment: MultiLineFragment = MultiLineFragment(content, body)
    let fragments: [Fragment?] = [documentation, initializerFragment, end()]
    return GroupFragment(children: fragments.compactMap { $0 })
}

/**
 Creates a Fragment formatted specifically as an initializer with no custom body other than assigning arguments.
 - parameters:
    - access       : The access level of the initializer
    - documentation: The documentation of the initializer
    - arguments    : The arguments of the initializer
    - throwsError : Bool flag indicating if the initializer throws or not

 - returns: A GroupFragment typed as a CodeRepresentable
 */
@inlinable
public func initializerSpec(
    access: Access = .internal,
    documentation: Documentation? = nil,
    arguments: [Argument],
    throwsError: Bool = false
) -> CodeRepresentable {
    let code: Code = arguments.map { SingleLineFragment("self.\($0.name) = \($0.name)")}.asCode
    return initializerSpec(access: access, documentation: documentation, arguments: arguments, throwsError: throwsError, { code })
}
