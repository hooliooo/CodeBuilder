//
//  String+Codebuilder.swift
//  
//
//  Created by Julio Miguel Alorro on 01.03.20.
//

import Foundation

public extension String {

    init(_ indent: String, @CodeBuilder builder: () -> [CodeFragment]) {
        let fragments = builder()
        self = fragments.reduce(into: "") { (curr, fragment) in
            if let multi = fragment as? MultiCodeFragment { multi.indent = indent }
            curr += fragment.renderContent()
        }
    }

}
