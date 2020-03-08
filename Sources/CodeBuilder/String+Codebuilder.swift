//
//  String+Codebuilder.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 01.03.20.
//

import Foundation

public extension String {

    init(_ indent: String, @CodeBuilder builder: () -> [Fragment]) {
        let fragments = builder()
        self = fragments.reduce(into: "") { (curr, fragment) in
            if let multi = fragment as? MultiLineFragment { multi.indent = indent }
            curr += fragment.renderContent()
        }
    }

}
