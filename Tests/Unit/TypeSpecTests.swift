import XCTest
@testable import CodeBuilder

final class TypeSpecTests: XCTestCase {

    private func generateString(@CodeBuilder _ builder: () -> CodeRepresentable) -> String {
        fileSpec(indent: "    ", builder)
    }

    func testTypeSpecAccess() {
        let example: String = """
                              class Test {

                              }

                              """
        let docString: String = generateString {
            typeSpec("Test", access: Access.internal, type: DataType.class)
        }

        let example2: String = """
                              public struct Test {

                              }

                              """
        let docString2: String = generateString {
            typeSpec("Test", access: Access.public, type: DataType.struct)
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
        XCTAssertTrue(example2 == docString2, "Both strings should equal each other")
    }

    func testTypeSpecInheritance() {
        let example: String = """
                              class Test: NSObject {

                              }

                              """
        let docString: String = generateString {
            typeSpec("Test", type: DataType.class, inheritingFrom: ["NSObject"])
        }

        let example2: String = """
                              class Test: NSObject, TestProtocolOne, TestProtocolTwo {

                              }

                              """
        let docString2: String = generateString {
            typeSpec("Test", type: DataType.class, inheritingFrom: ["NSObject", "TestProtocolOne", "TestProtocolTwo"])
        }

        let example3: String = """
                              struct Test: Hashable, TestProtocolOne, TestProtocolTwo {

                              }

                              """
        let docString3: String = generateString {
            typeSpec("Test", type: DataType.struct, inheritingFrom: ["Hashable", "TestProtocolOne", "TestProtocolTwo"])
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
        XCTAssertTrue(example2 == docString2, "Both strings should equal each other")
        XCTAssertTrue(example3 == docString3, "Both strings should equal each other")
    }

    func testTypeSpecBody() {
        let example: String = """
                              class Test {

                                  var testOne: String = "this"

                                  var testTwo: String = "this"

                                  func test() {
                                      print("Hello, World")
                                  }
                              }

                              """
        let docString: String = generateString {
            typeSpec("Test", type: DataType.class) {
                StoredProperty(access: Access.internal, isMutable: true, name: "testOne", type: "String", value: "\"this\"")
                lineBreak()
                StoredProperty(access: Access.internal, isMutable: true, name: "testTwo", type: "String", value: "\"this\"")
                lineBreak()
                functionSpec("test") {
                    statement("print(\"Hello, World\")")
                }
            }
        }

        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    func testTypeSpecClass() {
        let example: String = """
                              open class Test: NSObject, TestProtocolOne, TestProtocolTwo {

                                  init(testOne: String, testTwo: String) {
                                      self.testOne = testOne
                                      self.testTwo = testTwo
                                  }

                                  var testOne: String = "this"

                                  var testTwo: String = "this"

                                  func test() {
                                      print("Hello, World")
                                  }
                              }

                              """

        let propOne = StoredProperty(access: Access.internal, isMutable: true, name: "testOne", type: "String", value: "\"this\"")
        let propTwo = StoredProperty(access: Access.internal, isMutable: true, name: "testTwo", type: "String", value: "\"this\"")
        let docString: String = generateString {
            typeSpec(
                "Test",
                access: Access.open,
                type: DataType.class,
                inheritingFrom: ["NSObject", "TestProtocolOne", "TestProtocolTwo"]
            ) {
                initializerSpec(arguments: [propOne.asArgument, propTwo.asArgument])
                lineBreak()
                propOne
                lineBreak()
                propTwo
                lineBreak()
                functionSpec("test") {
                    statement("print(\"Hello, World\")")
                }
            }
        }
        print(example)
        print(docString)
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    static var allTests: [(String, (TypeSpecTests) -> () -> ())] = [
        ("testTypeSpecClass", testTypeSpecClass),
    ]
}
