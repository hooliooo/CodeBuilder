//
//  String+Codebuilder.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 07.04.20.
//

import Foundation

extension Array: CodeRepresentable where Element: CodeRepresentable {
    public var asCode: Code {
        return .fragments(self.flatMap { $0.asCode.fragments })
    }
}
