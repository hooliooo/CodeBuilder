//
//  ForEach.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 4/28/20.
//

import Foundation

/**
 A struct that enables interation through a collection.
 */
public struct ForEach<T: RandomAccessCollection>: CodeRepresentable {

    // MARK: Initializers
    /**
     Initializer
     - parameters:
        - elements: The collection of elements
        - builder: The CodeBuilder closure executed on each element of the collection
     */
    public init(_ elements: T, @CodeBuilder _ builder: @escaping (T.Element) -> CodeRepresentable) {
        self.elements = elements
        self.builder = builder
    }

    // MARK: Stored Properties
    /**
     A collection of elements to be iterated on
     */
    public let elements: T

    /**
     The closure executed on each element that produces a CodeRepresentable
     */
    public let builder: (T.Element) -> CodeRepresentable

    /**
     The CodeRepresentables created by the builder are joined together with line breaks in between
     */
    @inlinable
    public var asCode: Code {
        let representables: [CodeRepresentable] = self.elements.map { (element) -> CodeRepresentable in
            self.builder(element)
        }

        let fragments: [Fragment] = zip(representables, representables.dropFirst())
            .flatMap { (first, second) -> [Fragment] in
                first.asCode.fragments + [lineBreak()] + second.asCode.fragments
            }
        return Code.fragments(fragments)
    }
}
