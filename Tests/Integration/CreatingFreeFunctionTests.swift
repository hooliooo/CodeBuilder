import XCTest
@testable import CodeBuilder

final class FreeFunctionTests: XCTestCase {

    func testFreeFunction() {

        let expected: String = """
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

                              """
        let arg1 = Argument(name: "x", type: "Int")
        let arg2 = Argument(name: "y", type: "Int")
        let actual: String = fileSpec(fileName: "", indent: "    ") {
            documentationSpec(
                "Sums up two integers",
                format: Documentation.Format.multiline,
                parameters: [
                    arg1.asParameter(documentation: "First Int"),
                    arg2.asParameter(documentation: "Second Int")
                ], returns: "The sum of the two Ints"
            )
            functionSpec("sum", access: .public, arguments: [arg1, arg2], returnValue: "Int") {
                statement("return x + y")
            }
        }.string
        XCTAssert(expected == actual, "The two strings should equal each other")

    }

}

