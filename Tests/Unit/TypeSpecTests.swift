import XCTest
@testable import CodeBuilder

final class TypeSpecTests: XCTestCase {

    private func generateString(@CodeBuilder _ builder: () -> CodeRepresentable) -> String {
        fileSpec(indent: "    ", builder)
    }

    func testTypeSpecClass() {
        let example: String = """
                              class Test: NSObject {

                                  var testOne: String = "this"

                                  var testTwo: String = "this"

                              }

                              """
        let docString: String = generateString {
            typeSpec("Test", access: Access.internal, type: DataType.class, inheritingFrom: ["NSObject"]) {
                StoredProperty(access: Access.internal, isMutable: true, name: "testOne", type: "String", value: "\"this\"")
                lineBreak()
                StoredProperty(access: Access.internal, isMutable: true, name: "testTwo", type: "String", value: "\"this\"")
            }
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    static var allTests: [(String, (TypeSpecTests) -> () -> ())] = [
        ("testTypeSpecClass", testTypeSpecClass),
    ]
}
