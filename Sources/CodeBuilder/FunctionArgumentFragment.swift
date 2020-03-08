//
//  FunctionArgumentFragment.swift
//
//  Copyright (c) Julio Miguel Alorro 2019
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 06.03.20.
//

import Foundation

public struct FunctionArgumentFragment: Fragment {

    // MARK: Stored Properties
    public let name: String
    public let type: String

    public func renderContent() -> String {
        return "\(self.name): \(self.type)"
    }
}
