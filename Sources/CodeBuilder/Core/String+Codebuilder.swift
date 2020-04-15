//
//  String+Codebuilder.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 01.03.20.
//

import Foundation

public extension String {

    /**
     Creates a String instance using the Fragments created from the builder closure
     - parameters:
        - indent : The indent level used by the Fragments created in the function builder
        - builder: The closure that creates CodeRepresentable instances that represent Swift code
     */
    @inlinable
    init(_ indent: String, @CodeBuilder builder: () -> Code) {
        let fragments: [Fragment] = builder().fragments
        self = fragments.reduce(into: "") { (string: inout String, fragment: Fragment) -> Void in
            if let multi = fragment as? MultiLineFragment { multi.indent = indent }
            string += fragment.renderContent()
        }
    }

}
