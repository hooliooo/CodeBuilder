//
//  DocumentationTests.swift
//  
//
//  Created by Julio Miguel Alorro on 07.03.20.
//

import XCTest
@testable import CodeBuilder

//final class DocumentationTests: XCTestCase {
//
//    private func generateString(_ fragment: CodeFragment) -> String {
//        code(indent: "") {
//            fragment
//        }
//    }
//
//    func testContentMultiline() {
//        let content: String = "This is an example documentation"
//        let example: String = """
//                              /**
//                               \(content)
//                               */
//
//                              """
//        let docString: String = generateString(documentation(content, format: ParameterDocumentation.Format.multiline))
//        XCTAssertTrue(example == docString, "Both strings should equal each other")
//    }
//
//    func testParametersMultiline() {
//        let parameters = [
//            ParameterDocumentation(name: "testOne", documentation: "testOne represents some documentation"),
//            ParameterDocumentation(name: "testTwo", documentation: "testTwo represents some documentation"),
//            ParameterDocumentation(name: "testThree", documentation: "testThree represents some documentation"),
//        ]
//
//        let example: String = """
//                             /**
//
//                              - parameters:
//                                \(parameters[0].content(with: ParameterDocumentation.Format.multiline))
//                                \(parameters[1].content(with: ParameterDocumentation.Format.multiline))
//                                \(parameters[2].content(with: ParameterDocumentation.Format.multiline))
//                              */
//
//                             """
//
//        let docString: String = generateString(
//            documentation(
//                "",
//                format: ParameterDocumentation.Format.multiline,
//                parameters: parameters,
//                returnValue: nil, tag: nil
//            )
//        )
//        print(example)
//        print(docString)
//        XCTAssertTrue(example == docString, "Both strings should equal each other")
//    }
//
//    func testContentSingle() {
//        let content: String = "This is an example documentation"
//        let example: String = """
//                             /// \(content)
//
//                             """
//
//        let docString: String = generateString(documentation(content, format: ParameterDocumentation.Format.singleLine))
//        XCTAssertTrue(example == docString, "Both strings should equal each other")
//    }
//
//    static var allTests: [(String, (DocumentationTests) -> () -> ())] = [
//        ("testContentMultiline", testContentMultiline),
//        ("testContentSingle", testContentSingle),
//        ("testParametersMultiline", testParametersMultiline)
//    ]
//
//}

