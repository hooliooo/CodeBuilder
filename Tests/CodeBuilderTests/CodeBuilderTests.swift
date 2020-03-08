import XCTest
@testable import CodeBuilder

final class CodeBuilderTests: XCTestCase {
    func testCode() {
        print(
            code(indent: "    ") {
                documentation("Test doc for Test") as CodeFragment
                define("Test", type: .class, inheritingFrom: ["This", "That"]) {
                    documentation("Test doc2") as CodeFragment
                    PropertyCodeFragment(access: .public, isMutable: true, name: "testOne", type: "String", value: nil)
                    PropertyCodeFragment(access: .public, isMutable: false, name: "testTwo", type: "Bool", value: nil) as CodeFragment
                    documentation(
                        "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto.",
                        format: .multiline,
                        parameters: [
                            ParameterDocumentation(name: "testOne", documentation: "This is so cool"),
                            ParameterDocumentation(name: "testTwo", documentation: "This is so cool"),
                            ParameterDocumentation(name: "testThree", documentation: "This is so cool")
                        ],
                        returnValue: "String",
                        tag: "testDoc"
                    ) as CodeFragment
                    define("Test2", type: .struct) {
                        documentation("Test doc4") as CodeFragment
                        PropertyCodeFragment(access: .internal, isMutable: false, name: "testOne", type: "Bool", value: nil) as CodeFragment
                        documentation(
                            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto.",
                            format: .singleLine,
                            parameters: [
                                ParameterDocumentation(name: "testOne", documentation: "This is so cool"),
                                ParameterDocumentation(name: "testTwo", documentation: "This is so cool"),
                                ParameterDocumentation(name: "testThree", documentation: "This is so cool")
                            ],
                            returnValue: "String",
                            tag: "testDoc"
                        ) as CodeFragment
                        function(
                            "test",
                            arguments: [
                                FunctionArgument(name: "testOne", type: "String")
                            ],
                            returnValue: "String",
                            {
                                statement("let t: String = Hello, \"\\(testOne)\"")
                                statement("return t")
                            }
                        )
                        end()
                    }
                    end()
                }
                end()
            }
        )
    }

    static var allTests = [
        ("testCode", testCode),
    ]
}
