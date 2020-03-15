//
//  Parameter.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 06.03.20.
//

import Foundation

public struct Parameter: Fragment {

    // MARK: Stored Properties
    public let name: String
    public let documentation: String

    // MARK: Methods
    
    @inlinable
    public func renderContent() -> String {
        return "   - \(self.name): \(self.documentation)"
    }
}
