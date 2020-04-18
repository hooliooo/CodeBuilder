import XCTest

import IntegrationTests

var tests: [XCTestCaseEntry] = [
    FileSpecTests.allTests(),
    FreeFunctionTests.allTests(),
    ControlFlowSpecTest.allTests(),
    DocumentationSpecTests.allTests(),
    FunctionSpecTests.allTests()
]
XCTMain(tests)
