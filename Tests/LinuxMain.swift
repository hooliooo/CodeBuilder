import XCTest

import IntegrationTests

var tests: [XCTestCaseEntry] = [
    CodeBuilderTests.allTests(),
    ControlFlowTest.allTests(),
    DocumentationTests.allTests(),
    FunctionTests.allTests()
]
XCTMain(tests)
