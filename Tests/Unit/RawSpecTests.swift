import XCTest
@testable import CodeBuilder

final class RawSpecTests: XCTestCase {

    private func generateString(@CodeBuilder _ builder: () -> CodeRepresentable) -> String {
        fileSpec(fileName: "", indent: "    ", builder).string
    }

    func testSimpletest() {
        let rawString: String = """
                               class Test {
                                   private init() {

                                   }

                                   func testOne() {
                                       print(\"Hello, World\")
                                   }

                                   enum TestTwo {
                                       case one
                                       case two
                                   }
                               }
                               """
        let docString: String = generateString {
            rawSpec(rawString)
        }

        let content: String = rawString + "\n"
        XCTAssertTrue(content == docString, "Both strings should equal each other")
    }

}
