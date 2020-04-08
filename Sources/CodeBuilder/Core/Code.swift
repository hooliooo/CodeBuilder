//
//  File.swift
//  
//
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
    public var fragments: [Fragment] {
        switch self {
            case .fragment(let fragment): return [fragment]
            case .fragments(let fragments): return fragments
        }
    }

    public var asCode: Code {
        self
    }
}

public protocol CodeRepresentable {
    var asCode: Code { get }
}
