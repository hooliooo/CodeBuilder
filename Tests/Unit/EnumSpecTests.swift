import XCTest
@testable import CodeBuilder

final class EnumSpecTests: XCTestCase {

    private func generateString(@CodeBuilder _ builder: () -> CodeRepresentable) -> String {
        fileSpec(indent: "    ", builder)
    }

    func testEnumSpecAccess() {
        let example: String = """
                              public enum Test {

                              }

                              """
        let docString: String = generateString {
            enumSpec(
                access: .public,
                enumSpec: Enum(
                    name: "Test",
                    cases: []
                )
            )
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    func testEnumSpecCases() {
        let example: String = """
                              enum Test {

                                  case one
                                  case two
                                  case three(String, Data)

                              }

                              """
        let docString: String = generateString {
            enumSpec(
                enumSpec: Enum(
                    name: "Test",
                    cases: [
                        NormalEnumCase(name: "one"),
                        NormalEnumCase(name: "two"),
                        AssociatedValueEnumCase(name: "three", types: ["String", "Data"])
                    ]
                )
            )
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    func testEnumSpecInheritingProtocols() {
        let example: String = """
                              enum Test: TestProtocolOne, TestProtocolTwo {

                              }

                              """
        let docString: String = generateString {
            enumSpec(
                enumSpec: Enum(
                    name: "Test",
                    cases: []
                ),
                inheritingFrom: ["TestProtocolOne", "TestProtocolTwo"]
            )
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    func testEnumSpecBody() {
        let example: String = """
                              enum Test {

                                  var testProp: String {
                                      return "Hello, World"
                                  }

                                  func test() {
                                      print("Hello, World")
                                  }
                              }

                              """
        let docString: String = generateString {
            enumSpec(
                enumSpec: Enum(
                    name: "Test",
                    cases: []
                ),
                {
                    computedPropertySpec("testProp", returnValue: "String") {
                        statement(#"return "Hello, World""#)
                    }
                    lineBreak()
                    functionSpec("test") {
                        statement("print(\"Hello, World\")")
                    }
                }
            )
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    func testEnumSpecAll() {
        let example: String = """
                              enum Test: TestProtocolOne, TestProtocolTwo {

                                  case one
                                  case two
                                  case three(String, Data)

                                  var testProp: String {
                                      return "Hello, World"
                                  }

                                  func test() {
                                      print("Hello, World")
                                  }
                              }

                              """
        let docString: String = generateString {
            enumSpec(
                enumSpec: Enum(
                    name: "Test",
                    cases: [
                        NormalEnumCase(name: "one"),
                        NormalEnumCase(name: "two"),
                        AssociatedValueEnumCase(name: "three", types: ["String", "Data"])
                    ]
                ),
                inheritingFrom: ["TestProtocolOne", "TestProtocolTwo"],
                {
                    computedPropertySpec("testProp", returnValue: "String") {
                        statement(#"return "Hello, World""#)
                    }
                    lineBreak()
                    functionSpec("test") {
                        statement("print(\"Hello, World\")")
                    }
                }
            )
        }
        print(example)
        print(docString)
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    static var allTests: [(String, (EnumSpecTests) -> () -> ())] = [
        ("testEnumSpecAccess", testEnumSpecAccess),
        ("testEnumSpecCases", testEnumSpecCases),
        ("testEnumSpecInheritingProtocols", testEnumSpecInheritingProtocols),
        ("testEnumSpecBody", testEnumSpecBody),
        ("testEnumSpecAll", testEnumSpecAll)
    ]
}
