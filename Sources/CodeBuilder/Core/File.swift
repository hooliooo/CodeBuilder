//
//  File.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 4/14/20.
//

import FileKit
import Foundation


/**
 A Swift file
 */
public struct File: CustomStringConvertible {

    // MARK: Static Properties

    /**
     A DateFormatter with a dateFormat of MM/dd/yyyy
     */
    @usableFromInline
    internal static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MM/dd/yyyy"
        return f
    }()

    // MARK: Initializers
    /**
     Creates a File instance which represents a Swift file that will be created

     - parameters:
        - name  : The name of the Swift file to be created
        - indent: The string used as indent characters. Should only be whitespace
        - body  : The Swift code that represents the body of the file
     */
    @inlinable
    public init(name: String, indent: String, @CodeBuilder body: () -> CodeRepresentable) {
        self.name = name
        self.indent = indent

        let date: Date = Date()
        self.date = date
        let formattingCode: Code = [
            SingleLineFragment("/// Generated code by CodeBuilder on \(File.formatter.string(from: date)) - DO NOT EDIT!"),
            lineBreak()
        ].asCode
        let code: Code = body().asCode

        self.code = GroupFragment(children: [formattingCode] + [code]).asCode
        self.originalCode = code
    }

    // MARK: Stored Properties

    /// The name of the Swift file
    public let name: String

    /// The string used for indenting Swift code
    public let indent: String

    /// The current date at the creation of this instance
    public let date: Date

    /// The body of the Swift file
    public let code: Code

    /// The orginial code without the added lines
    @usableFromInline
    internal let originalCode: Code

    // MARK: Computed Properties
    public var description: String {
        return """
               File name: \(self.name).swift
               File contents:
               \(String(self.indent, builder: { self.code}))
               """
    }

    /**
     A String representation of the File's code content
     */
    public var string: String {
        String(self.indent, builder: { self.originalCode })
    }

    // MARK: Methods
    /**
     Creates/overwrites a Swift file at the given path. Throws if there is an error encountered during the I/O operation
     - parameters:
        - pathString: The string representation of a file path. For example "~/Downloads"
     */
    @inlinable
    public func write(to pathString: String = "") throws {
        let path: Path
        switch pathString.isEmpty {
            case true:
                path = Path.current
            case false:
                path = Path(pathString)
        }

        let string: String = String(self.indent, builder: { self.code })
        let file: TextFile = TextFile(path: path + self.name)
        file.pathExtension = "swift"

        try string |> file
    }

}
