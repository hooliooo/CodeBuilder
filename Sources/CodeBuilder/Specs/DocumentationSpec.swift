//
//  DocumentationSpec.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 15.03.20.
//

import Foundation

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
@inlinable public func documentationSpec(
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
