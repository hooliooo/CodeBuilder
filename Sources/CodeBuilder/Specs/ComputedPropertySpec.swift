//
//  CodeBuilder
//  Copyright (c) Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import Foundation

/**
 Creates a Fragment formatted specifically for Swift computed properties
 - parameters:
    - name: The name of the computed property
    - access: The access level of the the computed property
    - isStatic: Bool flag that determines whether or not the computed property is static
    - returnValue: The return value of the function
    - body: Fragments that represent the body of the computed property

 - returns: A GroupFragment typed as CodeRepresentable
 */
@inlinable
public func computedPropertySpec(
    _ name: String,
    access: Access = .internal,
    isStatic: Bool = false,
    returnValue: String,
    @CodeBuilder _ body: () -> CodeRepresentable
) -> CodeRepresentable {
    let access: String = access == .internal ? "" : "\(access.rawValue) "
    let type: String = isStatic ? "static " : ""
    let content: String = "\(access)\(type)var \(name): \(returnValue) {"
    return GroupFragment(children: [MultiLineFragment(content, body), end()].asCode)
}
