//
//  InitializerSpec.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 4/11/20.
//

import Foundation
import Core

@inlinable
public func initializerSpec(access: Access = .internal, documentation: Documentation? = nil, arguments: [Argument], @CodeBuilder _ body: () -> CodeRepresentable) -> CodeRepresentable {
    let access: String = access == .internal ? "" : "\(access.rawValue) "
    let args: String = !arguments.isEmpty ? arguments.map { $0.renderContent() }.joined(separator: ", ") : ""
    let content: String = "\(access)init(\(args)) {"
    let initializerFragment: MultiLineFragment = MultiLineFragment(content, body)
    let fragments: [Fragment?] = [documentation, initializerFragment, end()]
    return GroupFragment(fragments: fragments.compactMap { $0 })
}

@inlinable
public func initializerSpec(access: Access = .internal, documentation: Documentation? = nil, arguments: [Argument]) -> CodeRepresentable {
    let fragments: [Fragment] = arguments.map { SingleLineFragment("self.\($0.name) = \($0.name)")}
    let code: Code = Code.fragments(fragments)
    return initializerSpec(access: access, documentation: documentation, arguments: arguments, { code })
}
