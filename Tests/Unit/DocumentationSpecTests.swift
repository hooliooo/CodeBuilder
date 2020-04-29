import XCTest
@testable import CodeBuilder

final class DocumentationSpecTests: XCTestCase {

    private func generateString(_ code: CodeRepresentable) -> String {
        fileSpec(fileName: "", indent: "    ") {
            code
        }.string
    }

    func testContentMultiline() {
        let content: String = "This is an example documentation"
        let example: String = """
                              /**
                               \(content)
                               */

                              """
        let docString: String = generateString(documentationSpec(content, format: Documentation.Format.multiline))
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testParametersMultiline() {
        let parameters = [
            Parameter(name: "testOne", documentation: "testOne represents some documentation"),
            Parameter(name: "testTwo", documentation: "testTwo represents some documentation"),
            Parameter(name: "testThree", documentation: "testThree represents some documentation"),
        ]

        let example: String = """
                             /**

                              - parameters:
                              \(parameters[0].renderContent())
                              \(parameters[1].renderContent())
                              \(parameters[2].renderContent())
                              */

                             """

        let docString: String = generateString(
            documentationSpec(
                "",
                format: Documentation.Format.multiline,
                parameters: parameters
            )
        )
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testReturnValueMultiline() {
        let example: String = """
                             /**

                              - returns: Some value
                              */

                             """

        let docString: String = generateString(
            documentationSpec(
                "",
                format: Documentation.Format.multiline,
                returns: "Some value"
            )
        )
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testTagMultiline() {
        let example: String = """
                             /**

                              - Tag: Some value
                              */

                             """

        let docString: String = generateString(
            documentationSpec(
                "",
                format: Documentation.Format.multiline,
                tag: "Some value"
            )
        )
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testMultiline() {
        let parameters = [
            Parameter(name: "testOne", documentation: "testOne represents some documentation"),
            Parameter(name: "testTwo", documentation: "testTwo represents some documentation"),
            Parameter(name: "testThree", documentation: "testThree represents some documentation"),
        ]
        let example: String = """
                             /**
                              Some content
                              - parameters:
                              \(parameters[0].renderContent())
                              \(parameters[1].renderContent())
                              \(parameters[2].renderContent())
                              - returns: Some return value
                              - Tag: Some tag
                              */

                             """

        let docString: String = generateString(
            documentationSpec(
                "Some content",
                format: Documentation.Format.multiline,
                parameters: parameters,
                returns: "Some return value",
                tag: "Some tag"
            )
        )
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testContentSingle() {
        let content: String = "This is an example documentation"
        let example: String = """
                             /// \(content)

                             """

        let docString: String = generateString(documentationSpec(content, format: Documentation.Format.singleLine))
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testParametersSingle() {
        let parameters = [
            Parameter(name: "testOne", documentation: "testOne represents some documentation"),
            Parameter(name: "testTwo", documentation: "testTwo represents some documentation"),
            Parameter(name: "testThree", documentation: "testThree represents some documentation"),
        ]

        let example: String = """
                             ///
                             /// - parameters:
                             /// \(parameters[0].renderContent())
                             /// \(parameters[1].renderContent())
                             /// \(parameters[2].renderContent())

                             """

        let docString: String = generateString(
            documentationSpec(
                "",
                format: Documentation.Format.singleLine,
                parameters: parameters
            )
        )

        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testReturnValueSingle() {
        let example: String = """
                             ///
                             /// - returns: Some value

                             """

        let docString: String = generateString(
            documentationSpec(
                "",
                format: Documentation.Format.singleLine,
                returns: "Some value"
            )
        )

        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testTagSingle() {
        let example: String =  """
                              ///
                              /// - Tag: Some value

                              """

        let docString: String = generateString(
            documentationSpec(
                "",
                format: Documentation.Format.singleLine,
                tag: "Some value"
            )
        )

        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testSingle() {
        let parameters = [
            Parameter(name: "testOne", documentation: "testOne represents some documentation"),
            Parameter(name: "testTwo", documentation: "testTwo represents some documentation"),
            Parameter(name: "testThree", documentation: "testThree represents some documentation"),
        ]
        let example: String = """
                             /// Some content
                             /// - parameters:
                             /// \(parameters[0].renderContent())
                             /// \(parameters[1].renderContent())
                             /// \(parameters[2].renderContent())
                             /// - returns: Some return value
                             /// - Tag: Some tag

                             """

        let docString: String = generateString(
            documentationSpec(
                "Some content",
                format: Documentation.Format.singleLine,
                parameters: parameters,
                returns: "Some return value",
                tag: "Some tag"
            )
        )
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    static var allTests: [(String, (DocumentationSpecTests) -> () -> ())] = [
        ("testContentMultiline", testContentMultiline),
        ("testParametersMultiline", testParametersMultiline),
        ("testReturnValueMultiline", testReturnValueMultiline),
        ("testTagMultiline", testTagMultiline),
        ("testMultiline", testMultiline),
        ("testContentSingle", testContentSingle),
        ("testParametersSingle", testParametersSingle),
        ("testReturnValueSingle", testReturnValueSingle),
        ("testTagSingle", testTagSingle),
        ("testSingle", testSingle)
    ]

}
