//
//  DocumentationSpec.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 15.03.20.
//

import Foundation
import Core

/**
 Create a CodeFragment formatted for documentation
 - parameters:
    - content            : The content of the documentation
    - format             : Determines whether or not the content will use single line or multiline documentaion notation
    - parameters         : The parameters documentation
    - returnsValue       : The return value documentation
    - tag                : The tag link to this documentation
 - returns:
    CodeFragment formatted specifically as documentation
 - Tag: documentation
 */
@inlinable
public func documentationSpec(
    _ content: String,
    format: Documentation.Format = .singleLine,
    parameters: [Parameter] = [],
    returns returnsValue: String? = nil,
    tag: String? = nil
) -> CodeRepresentable {
    let prefix: String = format == .singleLine ? "/// " : ""
    let content: String = "\(prefix)\(content)"

    let parameters: [Fragment?] = !parameters.isEmpty
        ? parameters.reduce(into: [SingleLineFragment("- parameters:")]) { $0.append(SingleLineFragment($1.renderContent())) }
        : []

    let returnString: Fragment? = returnsValue != nil
        ? SingleLineFragment("- returns: \(returnsValue!)")
        : nil

    let tag: Fragment? = tag != nil
        ? SingleLineFragment("- Tag: \(tag!)")
        : nil

    let fragments: [Fragment?] = parameters + [returnString, tag]
    return Documentation(content, format: format, { Code.fragments(fragments.compactMap { $0 }) })
}
