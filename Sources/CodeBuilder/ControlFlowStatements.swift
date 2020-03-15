//
//  ControlFlowStatemetns.swift
//
//  Copyright (c) Julio Miguel Alorro 2020
//  MIT license, see LICENSE file for details
//  Created by Julio Miguel Alorro on 08.03.20.
//

import Foundation

/**
 Creates a Fragment formatted specifically for Swift control flow statements

 Example:
 ```
 code("   ") {
    beginControlFlow("if word == \"That\"") {
        statement("print(\"Hello, \\(word)\")")
    }
    end()
 }
 ```
 renders:
 ```
 if word == "That" {
     print("Hello, \(word)")
 }
 ```

 - parameters:
    - statement: String representing the logic for the control flow.
    - builder: Fragments that represent the body of the control flow.
 */
public func beginControlFlow(_ statement: String, @CodeBuilder _ builder: () -> [Fragment]) -> Fragment {
    MultiLineFragment("\(statement) {", builder)
}

/**
 Creates a Fragment formatted specifically for Swift control flow statements

 Example:
 ```
 code("   ") {
    beginControlFlow("if word == \"That\"") {
        statement("print(\"Hello, \\(word)\")")
    }
    end()
 }
 ```
 renders:
 ```
 if word == "That" {
     print("Hello, \(word)")
 }
 ```

 - parameters:
    - statement: String representing the logic for the control flow.
    - builder: Fragment that represent the body of the control flow.
 */
public func beginControlFlow(_ statement: String, @CodeBuilder _ builder: () -> Fragment) -> Fragment {
    MultiLineFragment("\(statement) {", { [builder()] })
}

/**
 Creates a Fragment formatted specifically for `else if` Swift control flow statements

 Example:
 ```
 code("   ") {
    beginControlFlow("if word == \"That\"") {
        statement("print(\"word is That\")")
    }
    elseIf("word == \"This\"") {
        statement("print(\"word is This\")")
    }
    end()
 }
 ```
 renders:
 ```
 if word == "That" {
     print("word is That")
 } else if word == "This" {
     print("word is This")
 }
 ```

 - parameters:
    - statement: String representing the Bool logic for the `else if` control flow.
    - builder: Fragments that represent the body of the `else if` control flow.
 */
public func elseIf(_ statement: String, @CodeBuilder _ builder: () -> [Fragment]) -> Fragment {
    let t = MultiLineFragment("} else if \(statement) {", builder)
    return t
}

/**
 Creates a Fragment formatted specifically for `else if` Swift control flow statements

 Example:
 ```
 code("   ") {
    beginControlFlow("if word == \"That\"") {
        statement("print(\"word is That\")")
    }
    elseIf("word == \"This\"") {
        statement("print(\"word is This\")")
    }
    end()
 }
 ```
 renders:
 ```
 if word == "That" {
     print("word is That")
 } else if word == "This" {
     print("word is This")
 }
 ```

 - parameters:
    - statement: String representing the Bool logic for the `else if` control flow.
    - builder: Fragments that represent the body of the `else if` control flow.
 */
public func elseIf(_ statement: String, @CodeBuilder _ builder: () -> Fragment) -> Fragment {
    MultiLineFragment("} else if \(statement) {", { [builder()] })
}

/**
 Creates a Fragment formatted specifically for `else` Swift control flow statements

 Example:
 ```
 code("   ") {
    beginControlFlow("if word == \"That\"") {
        statement("print(\"word is That\")")
    }
    elseIf("word == \"This\"") {
        statement("print(\"word is This\")")
    }
    elseControlFlow {
        statement("print(\"word is neither That or This\")")
    }
    end()
 }
 ```
 renders:
 ```
 if word == "That" {
     print("word is That")
 } else if word == "This" {
     print("word is This")
 } else {
    print("word is neither That or This")
 }
 ```

 - parameters:
    - builder: Fragments that represent the body of the `else` control flow.
 */
public func elseControlFlow(@CodeBuilder _ builder: () -> [Fragment]) -> Fragment {
    MultiLineFragment("} else {", builder)
}

/**
 Creates a Fragment formatted specifically for `else` Swift control flow statements

 Example:
 ```
 code("   ") {
    beginControlFlow("if word == \"That\"") {
        statement("print(\"word is That\")")
    }
    elseIf("word == \"This\"") {
        statement("print(\"word is This\")")
    }
    elseControlFlow {
        statement("print(\"word is neither That or This\")")
    }
    end()
 }
 ```
 renders:
 ```
 if word == "That" {
     print("word is That")
 } else if word == "This" {
     print("word is This")
 } else {
    print("word is neither That or This")
 }
 ```

 - parameters:
    - builder: Fragment that represent the body of the `else` control flow.
 */
public func elseControlFlow(@CodeBuilder _ builder: () -> Fragment) -> Fragment {
    MultiLineFragment("} else {", { [builder()] })
}
