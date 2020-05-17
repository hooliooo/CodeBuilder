import XCTest
@testable import CodeBuilder

protocol ReadableTestCase {}
extension ReadableTestCase {
    func message(expected string: String, actual actualString: String) -> String {
        return """
               Both strings should equal each other
               Example:
               \(string)
               Actual:
               \(actualString)
               """
    }
}

extension XCTestCase: ReadableTestCase {}

final class EnumSpecTests: XCTestCase {

    private func generateString(@CodeBuilder _ builder: () -> CodeRepresentable) -> String {
        fileSpec(fileName: "", indent: "    ", builder).string
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
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
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
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
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
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
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
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testEnumSpecAll() {
        let example: String = """
                              private enum Test: TestProtocolOne, TestProtocolTwo {

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
                access: .private,
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
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testRawValueEnumSpecAccess() {
        let example: String = """
                              public enum Test: String {

                              }

                              """
        let docString: String = generateString {
            rawValueEnumSpec(
                access: .public,
                enumSpec: RawValueEnum<String>(
                    name: "Test",
                    cases: []
                )
            )
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testRawValueEnumSpecCases() {
        let example: String = """
                              enum Test: String {
                                  case test = "Hello"
                                  case testTwo = "World"
                                  case testThree
                              }

                              """
        let docString: String = generateString {
            rawValueEnumSpec(
                enumSpec: RawValueEnum<String>(
                    name: "Test",
                    cases: [
                        RawValueEnumCase(name: "test", value: #""Hello""#),
                        RawValueEnumCase(name: "testTwo", value: #""World""#),
                        RawValueEnumCase(name: "testThree", value: nil)
                    ]
                )
            )
        }

        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testRawValueEnumSpecInheritingProtocols() {
        let example: String = """
                              enum Test: String, TestProtocolOne, TestProtocolTwo {

                              }

                              """
        let docString: String = generateString {
            rawValueEnumSpec(
                enumSpec: RawValueEnum<String>(
                    name: "Test",
                    cases: []
                ),
                inheritingFrom: ["TestProtocolOne", "TestProtocolTwo"]
            )
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testRawValueEnumSpecBody() {
        let example: String = """
                              enum Test: String {

                                  var testProp: String {
                                      return "Hello, World"
                                  }

                                  func test() {
                                      print("Hello, World")
                                  }
                              }

                              """
        let docString: String = generateString {
            rawValueEnumSpec(
                enumSpec: RawValueEnum<String>(
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
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testRawValueEnumSpecAll() {
        let example: String = """
                              private enum Test: String, TestProtocolOne, TestProtocolTwo {
                                  case test = "Hello"
                                  case testTwo = "World"
                                  case testThree

                                  var testProp: String {
                                      return "Hello, World"
                                  }

                                  func test() {
                                      print("Hello, World")
                                  }
                              }

                              """
        let docString: String = generateString {
            rawValueEnumSpec(
                access: .private,
                enumSpec: RawValueEnum<String>(
                    name: "Test",
                    cases: [
                        RawValueEnumCase(name: "test", value: #""Hello""#),
                        RawValueEnumCase(name: "testTwo", value: #""World""#),
                        RawValueEnumCase(name: "testThree", value: nil)
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
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    static var allTests: [(String, (EnumSpecTests) -> () -> Void)] = [
        ("testEnumSpecAccess", testEnumSpecAccess),
        ("testEnumSpecCases", testEnumSpecCases),
        ("testEnumSpecInheritingProtocols", testEnumSpecInheritingProtocols),
        ("testEnumSpecBody", testEnumSpecBody),
        ("testEnumSpecAll", testEnumSpecAll),
        ("testRawValueEnumSpecAccess", testRawValueEnumSpecAccess),
        ("testRawValueEnumSpecCases", testRawValueEnumSpecCases),
        ("testRawValueEnumSpecInheritingProtocols", testRawValueEnumSpecInheritingProtocols),
        ("testRawValueEnumSpecBody", testRawValueEnumSpecBody),
        ("testRawValueEnumSpecAll", testRawValueEnumSpecAll)
    ]
}
