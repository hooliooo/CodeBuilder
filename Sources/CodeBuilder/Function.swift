//
//  FunctionArgument.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 06.03.20.
//

import Foundation

public class GroupFragment: MultiLineFragment {

    public init(children: [Fragment]) {
        super.init("", { children })
    }

    public override func renderContent() -> String {
        self.children
            .compactMap { (fragment: Fragment) -> MultiLineFragment? in
                fragment as? MultiLineFragment
            }
            .forEach {
                $0.parent = self.parent
                $0.indent = self.indent
            }


//        let indent: String = self.createIndent(with: 0)
        let content: String = self.children.reduce(into: "") { (currentContent: inout String, fragment: Fragment) -> Void in
            let fragmentContent: String = fragment.renderContent()
            if fragmentContent.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
                currentContent += fragmentContent
            } else {
                currentContent += (fragmentContent)
            }
        }

        return content
    }
}

public enum Function {
    public struct Argument: Fragment {

        // MARK: Stored Properties
        public let name: String
        public let type: String

        public func renderContent() -> String {
            return "\(self.name): \(self.type)"
        }
    }

}

