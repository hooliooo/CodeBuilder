//
//  CodeFragment.swift
//  
//
//  Created by Julio Miguel Alorro on 01.03.20.
//

import Foundation

/**
 Represents a line or block of Swift code
 */
public protocol CodeFragment {

    /**
     Generates a String representation of the Swift code represented by this CodeFragment
     */
    func renderContent() -> String

}
