//
//  CodeBuilder
//  Copyright (c) Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import Foundation

/**
 Represents keywords on a function after the arguments
 */
public enum FunctionKeyword: Hashable {
    /**
     THe async keyword
     */
    case `async`
    /**
     The throw or rethrows keyword. Represented as an associated value because in a given function,
     either throws or rethrows is used but not both at the same time
     */
    case throwing(ThrowKeyword)
}

extension FunctionKeyword: Comparable {
    public static func < (lhs: FunctionKeyword, rhs: FunctionKeyword) -> Bool {
        switch (lhs, rhs) {
            case (.async, .throwing): return true
            case (.throwing, .async): return false
            case (.throwing, .throwing): return false
            case (.async, .async): return false
        }
    }
}
/**
 Represents the throw and rethrow keywords on a function
 */
public enum ThrowKeyword: String {
    /**
     THe throws keyword
     */
    case `throws`
    /**
     THe rethrows keyword
     */
    case `rethrows`
}
