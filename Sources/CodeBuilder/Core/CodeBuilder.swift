//
//  CodeBuilder.swift
//  
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 01.03.20.
//

import Foundation

@_functionBuilder
public struct CodeBuilder {
//    public static func buildBlock() -> Code {
//        Code.none
//    }

    public static func buildBlock(_ components: CodeRepresentable...) -> Code {
        components.asCode
    }

    public static func buildOptional(_ component: CodeRepresentable?) -> Code {
        guard let component = component else { return Code.none }
        return component.asCode
    }

    public static func buildArray(_ components: [CodeRepresentable]) -> Code {
        components.asCode
    }

    public static func buildEither(first: CodeRepresentable) -> Code {
        first.asCode
    }

    public static func buildEither(second: CodeRepresentable) -> Code {
        second.asCode
    }
}
