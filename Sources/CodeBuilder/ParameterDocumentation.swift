//
//  ParameterDocumentation.swift
//  
//
//  Created by Julio Miguel Alorro on 06.03.20.
//

import Foundation

public struct ParameterDocumentation {

    // MARK: Stored Properties
    public let name: String
    public let documentation: String

    // MARK: Methods
    
    public func renderContent() -> String {
        return "   - \(self.name): \(self.documentation)"
    }

    public enum Format {
        case singleLine
        case multiline
    }
}
