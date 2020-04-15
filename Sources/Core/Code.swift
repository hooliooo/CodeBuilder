//
//  Code.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 07.04.20.
//

import Foundation

/**
 An enum that can unify a single Fragment and an array of Fragments into one type
 */
public enum Code: CodeRepresentable {

    /**
     A Fragment
     */
    case fragment(Fragment)

    /**
     Several Fragments
     */
    case fragments([Fragment])

    /**
     Code as an array of Fragments
     */
    @inlinable
    public var fragments: [Fragment] {
        switch self {
            case .fragment(let fragment): return [fragment]
            case .fragments(let fragments): return fragments
        }
    }

    @inlinable
    public var asCode: Code {
        self
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
