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
 fileSpec("   ") {
    controlFlowSpec("if word == \"That\"") {
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
@inlinable
public func controlFlowSpec(_ statement: String, @CodeBuilder _ builder: () -> [Fragment]) -> Fragment {
    MultiLineFragment("\(statement) {", builder)
}

/**
 Creates a Fragment formatted specifically for Swift control flow statements

 Example:
 ```
 fileSpec("   ") {
    controlFlowSpec("if word == \"That\"") {
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
@inlinable
public func controlFlowSpec(_ statement: String, @CodeBuilder _ builder: () -> Fragment) -> Fragment {
    controlFlowSpec(statement, { [builder()] })
}

/**
 Creates a Fragment formatted specifically for `else if` Swift control flow statements

 Example:
 ```
 fileSpec("   ") {
    controlFlowSpec("if word == \"That\"") {
        statement("print(\"word is That\")")
    }
    elseIfSpec("word == \"This\"") {
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
@inlinable
public func elseIfSpec(_ statement: String, @CodeBuilder _ builder: () -> [Fragment]) -> Fragment {
    MultiLineFragment("} else if \(statement) {", builder)
}

/**
 Creates a Fragment formatted specifically for `else if` Swift control flow statements

 Example:
 ```
 fileSpec("   ") {
    controlFlowSpec("if word == \"That\"") {
        statement("print(\"word is That\")")
    }
    elseIfSpec("word == \"This\"") {
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
@inlinable
public func elseIfSpec(_ statement: String, @CodeBuilder _ builder: () -> Fragment) -> Fragment {
    elseIfSpec(statement, { [builder()] })
}

/**
 Creates a Fragment formatted specifically for `else` Swift control flow statements

 Example:
 ```
 fileSpec("   ") {
    controlFlowSpec("if word == \"That\"") {
        statement("print(\"word is That\")")
    }
    elseIfSpec("word == \"This\"") {
        statement("print(\"word is This\")")
    }
    elseSpec {
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
@inlinable
public func elseSpec(@CodeBuilder _ builder: () -> [Fragment]) -> Fragment {
    MultiLineFragment("} else {", builder)
}

/**
 Creates a Fragment formatted specifically for `else` Swift control flow statements

 Example:
 ```
 fileSpec("   ") {
    controlFlowSpec("if word == \"That\"") {
        statement("print(\"word is That\")")
    }
    elseIfSpec("word == \"This\"") {
        statement("print(\"word is This\")")
    }
    elseSpec {
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
@inlinable
public func elseSpec(@CodeBuilder _ builder: () -> Fragment) -> Fragment {
    elseSpec { [builder()] }
}

/**
 Creates a Fragment formatted specifically for `guard` Swift control flow statements

 Example:
 ```
 fileSpec("   ") {
     guardSpec(
         statements: {
             statement("x == 0")
             statement("y == 0")
         },
         elseBlock: {
             statement(
                 """
                print("Bool failed")
                """
             )
             statement("return")
         }
     )
 }
 ```
 renders:
 ```
 guard
     x == 0,
     y == 0
 else {
     print("Bool failed")
     return
 }
 ```

 - parameters:
    - statements: The Fragments that represent the `guard` control flow's body.
    - elseBlock : The Fragment that represent a `guard` control flow's else block.
 - Tag: mainGuardSpec
*/
@inlinable
public func guardSpec(@CodeBuilder statements: () -> [Fragment], @CodeBuilder elseBlock: () -> [Fragment]) -> Fragment {
    let statements: [Fragment] = statements()
    var content: String = "guard"
    let fragments: [Fragment]
    if statements.count > 1, let statements = statements as? [SingleLineFragment] {
        let lastStatement: SingleLineFragment = statements.last!
        let newStatements: [SingleLineFragment] = statements
            .dropLast()
            .map {
                SingleLineFragment($0.content + ",")
            }
        fragments = [
            MultiLineFragment(content, { newStatements + [lastStatement] }),
            MultiLineFragment("else {", elseBlock)
        ]
    } else if let statement = statements.first {
        content += " "
        content += statement.renderContent().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        content += " else {"
        fragments = [MultiLineFragment(content, elseBlock)]
    } else {
        fragments = []
    }
    return GroupFragment(children: fragments + [end()])
}

/**
 Convenience method of [guardSpec](x-source-tag://mainGuardSpec)

 - parameters:
    - statement: The single Fragment that represents the `guard` control flow's body.
    - elseBlock: The single Fragment that represents the `guard` control flow's else block.
 */
@inlinable
public func guardSpec(@CodeBuilder statement: () -> Fragment, @CodeBuilder elseBlock: () -> Fragment) -> Fragment {
    guardSpec(statements: { [statement()] }, elseBlock: { [elseBlock()] })
}

/**
Convenience method of [guardSpec](x-source-tag://mainGuardSpec)

- parameters:
   - statement: The Fragments that represents the `guard` control flow's body.
   - elseBlock: The single Fragment that represents the `guard` control flow's else block.
*/
@inlinable
public func guardSpec(@CodeBuilder statements: () -> [Fragment], @CodeBuilder elseBlock: () -> Fragment) -> Fragment {
    guardSpec(statements: statements, elseBlock: { [elseBlock()] })
}

/**
Convenience method of [guardSpec](x-source-tag://mainGuardSpec)

- parameters:
   - statement: The single Fragment that represents the `guard` control flow's body.
   - elseBlock: The Fragments that represents the `guard` control flow's else block.
*/
@inlinable
public func guardSpec(@CodeBuilder statement: () -> Fragment, @CodeBuilder elseBlock: () -> [Fragment]) -> Fragment {
    guardSpec(statements: { [statement()] }, elseBlock: elseBlock)
}

@inlinable
public func doSpec(@CodeBuilder _ builder: () -> [Fragment]) -> Fragment {
    controlFlowSpec("do", builder)
}

@inlinable
public func doSpec(@CodeBuilder _ builder: () -> Fragment) -> Fragment {
    doSpec { [builder()] }
}

@inlinable
public func catchSpec(statement: String, @CodeBuilder _ builder: () -> [Fragment]) -> Fragment {
    MultiLineFragment("} catch \(statement) {", builder)
}

@inlinable
public func catchSpec(statement: String, @CodeBuilder _ builder: () -> Fragment) -> Fragment {
    catchSpec(statement: statement) { [builder()] }
}
