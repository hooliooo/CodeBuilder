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
    - returnsValue       : The return value documentation
    - tag                : The tag link to this documentation
 - returns: A Documentation typed as CodeRepresentable
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

    let returnString: Fragment? = {
        guard let returnsValue = returnsValue else { return nil }
        return SingleLineFragment("- returns: \(returnsValue)")
    }()

    let tag: Fragment? = {
        guard let tag = tag else { return nil }
        return SingleLineFragment("- Tag: \(tag)")
    }()

    let fragments: [Fragment?] = parameters + [returnString, tag]
    return Documentation(content, format: format, { fragments.compactMap { $0 }.asCode })
}
