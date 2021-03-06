# CodeBuilder

CodeBuilder started out as an exercise learning about Swift function builders then evolved into a small library that leverages function builders to create Swift code/files.

## Installation
### [Swift Package Manager](https://swift.org/package-manager/)

The Swift Package Manager is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

```swift
dependencies: [
     .package(url: "https://github.com/hooliooo/CodeBuilder.git", from: "0.1.0")
]
```
## Documentation
Can be found at https://hooliooo.github.io/CodeBuilder/

## Example

```swift
/// Create file using the simple API
let arg1 = Argument(name: "x", type: "Int")
let arg2 = Argument(name: "y", type: "Int")
let file: File = fileSpec(fileName: "Test", indent: "    ") {
    documentationSpec(
        "Sums up two integers",
        format: Documentation.Format.multiline,
        parameters: [
            arg1.asParameter(documentation: "First Int"),
            arg2.asParameter(documentation: "Second Int")
        ], 
        returns: "The sum of the two Ints"
    )
    functionSpec("sum", access: .public, arguments: [arg1, arg2], returnValue: "Int") {
        statement("return x + y")
    }
}

/// print(file.string) yields the following Swift code as a string

/**
 Sums up two integers
 - parameters:
    - x: First Int
    - y: Second Int
 - returns: The sum of the two Ints
 */
public func sum(x: Int, y: Int) -> Int {
    return x + y
}

/// Calling the following code will create a swift file named Test.swift to your Downloads folder
try! file.write(to: "/path/to/your/Downloads")

```

## License

CodeBuilder is released under the MIT license. [See LICENSE](https://github.com/hooliooo/CodeBuilder/blob/master/LICENSE) for details.
