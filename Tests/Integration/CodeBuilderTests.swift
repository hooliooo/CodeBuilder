import XCTest
@testable import CodeBuilder

final class CodeBuilderTests: XCTestCase {
    func testCode() {
        print(
            fileSpec(indent: "    ") {
                documentationSpec("Test doc for Test")
//                typeSpec("Test", type: .class, inheritingFrom: ["This", "That"]) {
//                    documentationSpec("Test doc2")
//                    Property(access: .public, isMutable: true, name: "testOne", type: "String", value: nil)
//                    Property(access: .public, isMutable: false, name: "testTwo", type: "Bool", value: nil)
//                    documentationSpec(
//                        "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto.",
//                        format: .multiline,
//                        parameters: [
//                            Parameter(name: "testOne", documentation: "This is so cool"),
//                            Parameter(name: "testTwo", documentation: "This is so cool"),
//                            Parameter(name: "testThree", documentation: "This is so cool")
//                        ],
//                        returnValue: "String",
//                        tag: "testDoc"
//                    )
//                    typeSpec("Test2", type: .struct) {
//                        documentationSpec("Test doc4")
//                        Property(access: .internal, isMutable: false, name: "testOne", type: "Bool", value: nil)
//                        documentationSpec(
//                            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto.",
//                            format: .singleLine,
//                            parameters: [
//                                Parameter(name: "testOne", documentation: "This is so cool"),
//                                Parameter(name: "testTwo", documentation: "This is so cool"),
//                                Parameter(name: "testThree", documentation: "This is so cool")
//                            ],
//                            returnValue: "String",
//                            tag: "testDoc"
//                        )
//                        functionSpec(
//                            "test",
//                            arguments: [
//                                Function.Argument(name: "testOne", type: "String")
//                            ],
//                            returnValue: "String",
//                            {
//                                statement("let t: String = Hello, \"\\(testOne)\"")
//                                statement("return t")
//                            }
//                        )
//                    }
//                }
            }
        )
    }

    static var allTests = [
        ("testCode", testCode),
    ]
}
