//
//  Function.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 15.03.20.
//

import Foundation

public enum Function {
    public struct Argument: Fragment {

        // MARK: Stored Properties
        public let name: String
        public let type: String

        @inlinable public func renderContent() -> String {
            return "\(self.name): \(self.type)"
        }
    }

}
