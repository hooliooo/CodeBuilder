import XCTest
@testable import CodeBuilder

final class CodeBuilderTests: XCTestCase {
    func testCode() {
        print(
            code(indent: "    ") {
                documentation("Test doc for Test") as Fragment
                typeSpec("Test", type: .class, inheritingFrom: ["This", "That"]) {
                    documentation("Test doc2") as Fragment
                    Property(access: .public, isMutable: true, name: "testOne", type: "String", value: nil)
                    Property(access: .public, isMutable: false, name: "testTwo", type: "Bool", value: nil) as Fragment
                    documentation(
                        "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto.",
                        format: .multiline,
                        parameters: [
                            Parameter(name: "testOne", documentation: "This is so cool"),
                            Parameter(name: "testTwo", documentation: "This is so cool"),
                            Parameter(name: "testThree", documentation: "This is so cool")
                        ],
                        returnValue: "String",
                        tag: "testDoc"
                    ) as Fragment
                    typeSpec("Test2", type: .struct) {
                        documentation("Test doc4") as Fragment
                        Property(access: .internal, isMutable: false, name: "testOne", type: "Bool", value: nil) as Fragment
                        documentation(
                            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto.",
                            format: .singleLine,
                            parameters: [
                                Parameter(name: "testOne", documentation: "This is so cool"),
                                Parameter(name: "testTwo", documentation: "This is so cool"),
                                Parameter(name: "testThree", documentation: "This is so cool")
                            ],
                            returnValue: "String",
                            tag: "testDoc"
                        ) as Fragment
                        functionSpec(
                            "test",
                            arguments: [
                                Function.Argument(name: "testOne", type: "String")
                            ],
                            returnValue: "String",
                            {
                                statement("let t: String = Hello, \"\\(testOne)\"")
                                statement("return t")
                            }
                        )
                    }
                }
            }
        )
    }

    static var allTests = [
        ("testCode", testCode),
    ]
}
