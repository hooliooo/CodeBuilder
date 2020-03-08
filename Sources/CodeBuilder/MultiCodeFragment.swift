//
//  MultiLineFragment.swift
//
//  Copyright (c) Julio Miguel Alorro 2019
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 01.03.20.
//

import Foundation

/**
 A MultiLineFragment represents a multiple lines of Swift code
 */
class MultiLineFragment: Fragment {

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
     The type of formatting used for the code fragment as a String
     */
    public let type: Format

    /**
     The type of documentation format to be used. Either multiline or single line
     */
    public var documentationType: DocumentationFormat? {
        guard case let .documentation(format) = self.type else { return nil }
        return format
    }

    /**
     A MultiLineFragment represents a multiple lines of Swift code
     - parameters:
        - content: The content of this MultiLineFragment.
        - builder: The CodeFragments to be nested under this MultiLineFragment's content.
     */
    public init(_ content: String, type: Format = .code, @CodeBuilder _ builder: () -> [Fragment]) {
        self.content = content
        self.type = type
        self.children = builder()
    }

    private func createIndent(with startingLevel: Int) -> String {
        weak var parentsParent: MultiLineFragment? = self.parent
        var level: Int = startingLevel
        while parentsParent != nil {
           level += 1
           parentsParent = parentsParent?.parent
        }

        return String(repeating: self.indent, count: level)
    }

    private func lineBreak(content: String) -> (content: String,  truncatedContent: String?) {
        guard content.count > 130 else { return (content, nil) }
        let index = content.index(content.startIndex, offsetBy: 130)
        let words: Array<Substring> = content.split(separator: " ")

        let word = words.first(where: { $0.indices.contains(index) })!
        let truncateIndex = word.indices.endIndex
        let truncatedContent = content[truncateIndex...].dropFirst()
        let newContent = content[..<truncateIndex]
        return (String(newContent), String(truncatedContent))
    }

    private func renderContentAsCode() -> String {
        var content: String = self.content + "\n"
        let indent: String = self.createIndent(with: 1)
        content = self.children.reduce(into: content, { curr, fragment in
            curr += (indent + fragment.renderContent())
        })

        return content
    }

    private func renderContentAsDocumentation() -> String {
        let type = self.documentationType!
        let prefix: String = type == .singleLine ? "/// " : " "
        let (newContent, truncatedContent) = self.lineBreak(content: self.content)
        var content: String = (type == .singleLine ? newContent : "/**") + "\n"

        let indent: String = self.createIndent(with: 0)

        if type == .multiline {
            content += indent + prefix + SingleLineFragment(newContent).renderContent()
        }

        if let truncatedContent = truncatedContent {
            var moreTruncated = self.lineBreak(content: truncatedContent)
            repeat {
                content += (indent + prefix + SingleLineFragment(moreTruncated.content).renderContent())
                moreTruncated = self.lineBreak(content: moreTruncated.truncatedContent!)
            } while moreTruncated.truncatedContent != nil
        }

        content += self.children.reduce(into: "") { (string: inout String, fragment: Fragment) -> Void in
            string += (indent + prefix + fragment.renderContent())
        }

        if type == .multiline {
            content += indent + SingleLineFragment("*/").renderContent()
        }

        return content
    }

    public func renderContent() -> String {
        self.children
            .compactMap { (fragment: Fragment) -> MultiLineFragment? in
                fragment as? MultiLineFragment
            }
            .forEach {
                $0.parent = self
                $0.indent = self.indent
            }
        switch self.type {
            case .code:
                return self.renderContentAsCode()
            case .documentation:
                return self.renderContentAsDocumentation()
        }
    }

    public enum Format {
        case code
        case documentation(DocumentationFormat)
    }

}

public enum DocumentationFormat {
    case singleLine
    case multiline
}
