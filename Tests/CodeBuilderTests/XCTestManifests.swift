import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CodeBuilderTests.allTests),
        testCase(ControlFlowTest.allTests),
        testCase(DocumentationTests.allTests),
        testCase(FunctionTests.allTests),
    ]
}
#endif
