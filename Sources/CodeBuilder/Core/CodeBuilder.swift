//
//  CodeBuilder
//  Copyright (c) Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import Foundation

@resultBuilder
public struct CodeBuilder {

//    public static func buildArray(_ components: [CodeRepresentable]) -> Code {
//        components.asCode
//    }

    public static func buildBlock(_ components: CodeRepresentable...) -> Code {
        components.asCode
    }

    public static func buildEither(first: CodeRepresentable) -> Code {
        first.asCode
    }

    public static func buildEither(second: CodeRepresentable) -> Code {
        second.asCode
    }

//    public static func buildExpression(_ expression: CodeRepresentable) -> Code {
//        expression.asCode
//    }

//    public static func buildOptional(_ component: CodeRepresentable?) -> Code {
//        guard let component = component else { return Code.none }
//        return component.asCode
//    }
}
