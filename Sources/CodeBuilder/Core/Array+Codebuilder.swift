//
//  CodeBuilder
//  Copyright (c) Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import Foundation

extension Array: CodeRepresentable where Array.Element == CodeRepresentable {

    /**
     Transforms this Array into a Code.fragments instance that transforms each element into a [Fragment] instance
     and flatmaps it
     */
    public var asCode: Code {
        return .fragments(self.flatMap { $0.asCode.fragments })
    }
}

