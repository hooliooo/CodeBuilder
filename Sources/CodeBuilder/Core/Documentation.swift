//
//  CodeBuilder
//  Copyright (c) Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import Foundation

/**
 A MultilineFragment rendered specifically as documentation
 */
public class Documentation: MultiLineFragment {

    /**
     The formatting used to render this documentation. Either single line or multiline.
     */
    public let format: Documentation.Format

    /**
     Creates a MultilineFragment formatted specifically like documentation

     - parameters:
        - content : The main description of the documentation
        - format  : The formatting to be used by the content of the documentation. Either single line or multi line
        - children: The other parts of the documentation's content such as parameters, tag, return value, etc.
     */
    @inlinable
    public init(_ content: String, format: Documentation.Format = .singleLine, _ children: () -> CodeRepresentable) {
        self.format = format
        super.init(content, children)
    }

    /**
     Truncates content after 130 characters and returns the content to display up to 130 characters, followed by the rest of
     the content that was truncated.

     Does split a word. Simply truncates everything after the word at 130 characters.

     - parameters:
        - content: The String instance to truncate
     - returns:
        A tuple that contains the content that was truncated to 130 characters and the rest of the content, if there is any.
     */
    @usableFromInline
    func truncate(content: String) -> (content: String, truncatedContent: String?) {
        guard content.count > 130 else { return (content, nil) }
        let index: String.Index = content.index(content.startIndex, offsetBy: 130)
        
        if content[index].isWhitespace {
            let newContent: String.SubSequence = content[..<index]
            let truncatedContent: Substring.SubSequence = content[index...].dropFirst()
            return (String(newContent), String(truncatedContent))
        }
        
        let words: [Substring] = content.split(separator: " ")
        
        let word: Substring = words.first(where: { $0.indices.contains(index) })! // swiftlint:disable:this force_unwrapping
        let truncateIndex: Substring.Index = word.indices.endIndex
        let truncatedContent: Substring.SubSequence = content[truncateIndex...].dropFirst()
        let newContent: String.SubSequence = content[..<truncateIndex]
        return (String(newContent), String(truncatedContent))
    }

    /**
    Renders this Documentation as a string.

    The String format is as follows:
    ```
    /// This is a single line documentation format

    ```
     or
     ```
     /**
      This is a multiline documentation format
      */
     ```
    */
    @inlinable
    public override func renderContent() -> String {
        self.setUpChildren()
        let prefix: String = self.format == .singleLine ? "/// " : " "
        let (newContent, truncatedContent) = self.truncate(content: self.content)
        var content: String = (self.format == .singleLine
            ? newContent.trimmingCharacters(in: CharacterSet.whitespaces)
            : "/**") + "\n"

        let indent: String = self.createIndent(with: 0)

        if self.format == .multiline {
            content += !newContent.isEmpty
                ? indent + prefix + SingleLineFragment(newContent).renderContent()
                : "\n"
        }

        if let truncatedContent = truncatedContent {
            var moreTruncated = self.truncate(content: truncatedContent)
            
            repeat {
                content += (indent + prefix + SingleLineFragment(moreTruncated.content).renderContent())
                guard let truncatedContent = moreTruncated.truncatedContent else { break }
                moreTruncated = self.truncate(content: truncatedContent)
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

    /**
     An enum representing the two types of documentation formatting
     */
    public enum Format {

        /**
         Formats documentation with a "///" prefix
         */
        case singleLine

        /**
         Formats documentation with /** ... */ prefix and suffix
         */
        case multiline
    }

}
