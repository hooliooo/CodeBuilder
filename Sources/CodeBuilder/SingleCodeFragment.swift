//
//  SingleCodeFragment.swift
//  
//
//  Created by Julio Miguel Alorro on 01.03.20.
//

import Foundation

/**
 SingleCodeFragment represents a single line of Swift code
 */
public struct SingleCodeFragment: CodeFragment {

    /**
     The content of this SingleCodeFragment
     */
    public let content: String

    /**
     A SingleCodeFragment tepresents a single line of Swift code
     - parameters:
        - content: The textual representation of the Swift code this CodeFragment represents.
     */
    public init(_ content: String) {
        self.content = content
    }

    /**
     The SingleCodeFragment as a String. It is the content appended with a newline.
     */
    public func renderContent() -> String {
        return self.content + "\n"
    }

}
