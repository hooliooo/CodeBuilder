//
//  FunctionArgument.swift
//  
//
//  Created by Julio Miguel Alorro on 06.03.20.
//

import Foundation

public struct FunctionArgument {

    // MARK: Stored Properties
    public let name: String
    public let type: String

    // MARK: Methods
    /// The FunctionArgument formatted as a String
    public func content() -> String {
        return "\(self.name): \(self.type)"
    }
}
