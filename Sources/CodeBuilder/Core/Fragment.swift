//
//  Fragment.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 01.03.20.
//

import Foundation

/**
 Represents a line or block of Swift code
 */
public protocol Fragment: CodeRepresentable {

    /**
     Generates a String representation of the Swift code represented by this Fragment
     */
    @inlinable
    func renderContent() -> String

}

public extension Fragment {

    @inlinable
    var asCode: Code {
        .fragment(self)
    }

}
