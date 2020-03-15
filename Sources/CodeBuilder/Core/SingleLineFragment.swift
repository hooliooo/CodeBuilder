//
//  SingleLineFragment.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 01.03.20.
//

import Foundation

/**
 SingleLineFragment represents a single line of Swift code
 */
public struct SingleLineFragment: Fragment {

    /**
     The content of this SingleLineFragment
     */
    public let content: String

    /**
     A SingleLineFragment tepresents a single line of Swift code
     - parameters:
        - content: The textual representation of the Swift code this Fragment represents.
     */
    public init(_ content: String) {
        self.content = content
    }

    /**
     The SingleLineFragment as a String. It is the content appended with a newline.
     */
    @inlinable public func renderContent() -> String {
        return self.content + "\n"
    }

}
