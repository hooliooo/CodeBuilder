//
//  Documentation.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 08.03.20.
//

import Foundation

public class Documentation: MultiLineFragment {

    public let format: Documentation.Format

    public init(_ content: String, format: Documentation.Format = .singleLine, _ builder: () -> [Fragment]) {
        self.format = format
        super.init(content, builder)
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

    public override func renderContent() -> String {
        self.setUpChildren()
        let prefix: String = self.format == .singleLine ? "/// " : " "
        let (newContent, truncatedContent) = self.lineBreak(content: self.content)
        var content: String = (self.format == .singleLine ? newContent.trimmingCharacters(in: CharacterSet.whitespaces) : "/**") + "\n"

        let indent: String = self.createIndent(with: 0)

        if self.format == .multiline {
            content += !newContent.isEmpty
                ? indent + prefix + SingleLineFragment(newContent).renderContent()
                : "\n"
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

        if self.format == .multiline {
            content += indent + SingleLineFragment(" */").renderContent()
        }

        return content
    }

    public enum Format {
        case singleLine
        case multiline
    }
    
}
