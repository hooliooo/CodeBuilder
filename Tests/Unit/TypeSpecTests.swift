import XCTest
@testable import CodeBuilder

final class TypeSpecTests: XCTestCase {

    private func generateString(@CodeBuilder _ builder: () -> [Fragment]) -> String {
        fileSpec(indent: "    ", builder)
    }

    private func generateString(@CodeBuilder _ builder: () -> Fragment) -> String {
        generateString({ [builder()] })
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
                Property(access: Access.internal, isMutable: true, name: "testOne", type: "String", value: "\"this\"")
                lineBreak()
                Property(access: Access.internal, isMutable: true, name: "testTwo", type: "String", value: "\"this\"")
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
