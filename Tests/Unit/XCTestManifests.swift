import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FileSpecTests.allTests),
        testCase(FreeFunctionTests.allTests),
        testCase(ControlFlowSpecTest.allTests),
        testCase(DocumentationSpecTests.allTests),
        testCase(EnumSpecTests.allTests),
        testCase(FunctionSpecTests.allTests),
        testCase(TypeSpecTests.allTests)
    ]
}
#endif
