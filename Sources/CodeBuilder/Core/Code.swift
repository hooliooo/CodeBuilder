//
//  CodeBuilder
//  Copyright (c) Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import Foundation

/**
 An enum that can unify a single Fragment and an array of Fragments into one type
 */
public enum Code: CodeRepresentable, Equatable {

    /**
     A Fragment
     */
    case fragment(Fragment)

    /**
     Several Fragments
     */
    case fragments([Fragment])

    /**
     No fragments
     */
    case none

    /**
     Code as an array of Fragments
     */
    @inlinable
    public var fragments: [Fragment] {
        switch self {
            case .fragment(let fragment): return [fragment]
            case .fragments(let fragments): return fragments
            case .none: return []
        }
    }

    @inlinable
    public var asCode: Code {
        self
    }

    public static func == (lhs: Code, rhs: Code) -> Bool {
        switch (lhs, rhs) {
            case let (.fragment(lhsValue), .fragment(rhsValue)):
                return lhsValue.renderContent() == rhsValue.renderContent()
            case let (.fragments(lhsValue), .fragments(rhsValue)):
                return lhsValue.map { $0.renderContent() } == rhsValue.map { $0.renderContent() }
            case (.none, .none):
                return true
            default:
                return false
        }
    }
}

/**
 A type that represents a piece of Swift code
 */
public protocol CodeRepresentable {

    /**
     A representation of this CodeRepresentable instance as a Code case
     */
    @inlinable
    var asCode: Code { get }
}
