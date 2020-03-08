//
//  MultiCodeFragment.swift
//  
//
//  Created by Julio Miguel Alorro on 01.03.20.
//

import Foundation

/**
 A MultiCodeFragment represents a multiple lines of Swift code
 */
class MultiCodeFragment: CodeFragment {

    /**
     The content of the MultiCodeFragment
     */
    public let content: String

    /**
     The CodeFragmentType instances that will be indented in a newline below this MultiCodeFragment's content
     */
    public let children: [CodeFragment]

    /**
     The parent of this MultiCodeFragment, if there is one. Helps determine the level of indentation needed to render
     this MultiCodeFragment's content and children
     */
    public weak var parent: MultiCodeFragment?

    /**
     The string used to prefix the content of the String rendered by this MultiCodeFragment
     */
    public var indent: String = ""

    public let type: CodeType

    public var documentationType: ParameterDocumentation.Format? {
        guard case let .documentation(format) = self.type else { return nil }
        return format
    }

    /**
     A MultiCodeFragment represents a multiple lines of Swift code
     - parameters:
        - content: The content of this MultiCodeFragment.
        - builder: The CodeFragments to be nested under this MultiCodeFragment's content.
     */
    public init(_ content: String, type: CodeType = .code, @CodeBuilder _ builder: () -> [CodeFragment]) {
        self.content = content
        self.type = type
        self.children = builder()
    }

    private func renderContentAsCode() -> String {
        var content: String = self.content + "\n"
        let indent: String = self.createIndent()
        content = self.children.reduce(into: content, { curr, fragment in
            curr += (indent + fragment.renderContent())
        })

        return content
    }

    private func createIndent() -> String {
        weak var parentsParent: MultiCodeFragment? = self.parent
        var level: Int = 1
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

    private func renderContentAsDocumentation() -> String {
        let type = self.documentationType!
        let prefix: String = type == .singleLine ? "/// " : " "
        let (newContent, truncatedContent) = self.lineBreak(content: self.content)
        var content: String = type == .singleLine
            ? newContent + "\n"
            : "/**" + "\n"

        let indent: String
        weak var parentsParent: MultiCodeFragment? = self.parent
        var level: Int = 0
        while parentsParent != nil {
           level += 1
           parentsParent = parentsParent?.parent
        }

        indent = String(repeating: self.indent, count: level)

        if type == .multiline {
            content += indent + prefix + SingleCodeFragment(newContent).renderContent()
        }

        if let truncatedContent = truncatedContent {
            var moreTruncated = self.lineBreak(content: truncatedContent)
            repeat {
                content += (indent + prefix + SingleCodeFragment(moreTruncated.content).renderContent())
                moreTruncated = self.lineBreak(content: moreTruncated.truncatedContent!)
            } while moreTruncated.truncatedContent != nil
        }

        content += self.children.reduce(into: "") { (string: inout String, fragment: CodeFragment) -> Void in
            string += (indent + prefix + fragment.renderContent())
        }

        if type == .multiline {
            content += indent + " */\n"
        }

        return content
    }

    public func renderContent() -> String {
        self.children
            .compactMap { (fragment: CodeFragment) -> MultiCodeFragment? in
                fragment as? MultiCodeFragment
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

    public enum CodeType {
        case code
        case documentation(ParameterDocumentation.Format)
    }

}
