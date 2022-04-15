//
//  CodeBuilder
//  Copyright (c) Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import Foundation

/**
 A MultilineFragment that groups its children at the same indent level
 */
public class GroupFragment: MultiLineFragment {

    /**
     Creates a GroupFragment using a CodeRepresentable instance
     */
    @inlinable
    public init(children: CodeRepresentable) {
        super.init("", { children })
    }

    @inlinable
    public init(@CodeBuilder _ builder: () -> CodeRepresentable) {
        super.init("", builder)
    }

    @inlinable
    public override func renderContent() -> String {
        self.children.lazy
            .compactMap { (fragment: Fragment) -> MultiLineFragment? in
                fragment as? MultiLineFragment
            }
            .forEach {
                $0.parent = self.parent
                $0.indent = self.indent
            }
        let indent: String = self.createIndent(with: 0)
        let content: String = self.children.reduce(into: "") { (currentContent: inout String, fragment: Fragment) -> Void in
            let fragmentContent: String

            if let fragment = fragment as? MultiLineFragment {
                fragmentContent = fragment.renderContent()
            } else {
                fragmentContent = "\(indent)\(fragment.renderContent())"
            }

            currentContent += fragmentContent
        }

        return content
    }
}
