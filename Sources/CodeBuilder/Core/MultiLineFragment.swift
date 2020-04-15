//
//  MultiLineFragment.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 01.03.20.
//

import Foundation

/**
 A MultiLineFragment represents a multiple lines of Swift code where the children are indented under its content
 */
public class MultiLineFragment: Fragment {

    /**
     The content of the MultiLineFragment
     */
    public let content: String

    /**
     The CodeFragmentType instances that will be indented in a newline below this MultiLineFragment's content
     */
    public let children: [Fragment]

    /**
     The parent of this MultiCodeFragment, if there is one. Helps determine the level of indentation needed to render
     this MultiCodeFragment's content and children
     */
    public weak var parent: MultiLineFragment?

    /**
     The string used to prefix the content of the String rendered by this MultiLineFragment
     */
    public var indent: String = ""

    /**
     A MultiLineFragment represents a multiple lines of Swift code
     - parameters:
        - content: The content of this MultiLineFragment.
        - builder: The CodeFragments to be nested under this MultiLineFragment's content.
     */
    @inlinable
    public init(_ content: String, @CodeBuilder _ builder: () -> CodeRepresentable) {
        self.content = content
        self.children = builder().asCode.fragments
    }

    /**
     Creates an indent level based on the number of parents from this MultilineFragment
     - parameters:
        - startingLevel: Determines starting number to multiply the indent level
     - returns:
        returns a whitespace String representing the indent level to use.
     */
    @usableFromInline
    func createIndent(with startingLevel: Int) -> String {
        weak var parentsParent: MultiLineFragment? = self.parent
        var level: Int = startingLevel
        while parentsParent != nil {
           level += 1
           parentsParent = parentsParent?.parent
        }

        return String(repeating: self.indent, count: level)
    }

    /**
     Sets the indent level and parent of all children that are MultiLineFragments
     */
    @usableFromInline
    func setUpChildren() {
        self.children.lazy
            .compactMap { (fragment: Fragment) -> MultiLineFragment? in
                fragment as? MultiLineFragment
            }
            .forEach {
                $0.parent = self
                $0.indent = self.indent
            }
    }

    @inlinable
    public func renderContent() -> String {
        self.setUpChildren()
        var content: String = self.content + "\n"
        let indent: String = self.createIndent(with: 1)
        content = self.children.reduce(into: content) { (currentContent: inout String, fragment: Fragment) -> Void in
            let fragmentContent: String = fragment.renderContent()
            if fragmentContent.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
                currentContent += fragmentContent
            } else {
                currentContent += (indent + fragmentContent)
            }
        }

        return content
    }

}
