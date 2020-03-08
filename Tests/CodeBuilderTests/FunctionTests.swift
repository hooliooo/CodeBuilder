import XCTest
@testable import CodeBuilder

final class FunctionTests: XCTestCase {

    private func generateString(@CodeBuilder _ builder: () -> [Fragment]) -> String {
        code(indent: "    ", builder)
    }

    func testFunc() {
        let example: String = """
                             func testOne() {
                                 print(\"Hello, World\")
                             }

                             """
        let docString: String = generateString {
            function("testOne") {
                statement("print(\"Hello, World\")")
            }
            end()
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    func testFuncWithOpenAccess() {
        let example: String = """
                             open func testOne() {
                                 print(\"Hello, World\")
                             }

                             """
        let docString: String = generateString {
            function("testOne", access: .open) {
                statement("print(\"Hello, World\")")
            }
            end()
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    func testFuncWithPublicAccess() {
        let example: String = """
                             public func testOne() {
                                 print(\"Hello, World\")
                             }

                             """
        let docString: String = generateString {
            function("testOne", access: .public) {
                statement("print(\"Hello, World\")")
            }
            end()
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    func testFuncWithInternalAccess() {
        let example: String = """
                             func testOne() {
                                 print(\"Hello, World\")
                             }

                             """
        let docString: String = generateString {
            function("testOne", access: .internal) {
                statement("print(\"Hello, World\")")
            }
            end()
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    func testFuncWithFileprivateAccess() {
        let example: String = """
                             fileprivate func testOne() {
                                 print(\"Hello, World\")
                             }

                             """
        let docString: String = generateString {
            function("testOne", access: .fileprivate) {
                statement("print(\"Hello, World\")")
            }
            end()
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    func testFuncWithPrivateAccess() {
        let example: String = """
                             private func testOne() {
                                 print(\"Hello, World\")
                             }

                             """
        let docString: String = generateString {
            function("testOne", access: .private) {
                statement("print(\"Hello, World\")")
            }
            end()
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    func testStaticFunc() {
        let example: String = """
                             static func testOne() {
                                 print(\"Hello, World\")
                             }

                             """
        let docString: String = generateString {
            function("testOne", isStatic: true) {
                statement("print(\"Hello, World\")")
            }
            end()
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    func testGenericFunc() {
        let example: String = """
                             func testOne<T: NSObject>() {
                                 print(\"Hello, World\")
                             }

                             """
        let docString: String = generateString {
            function("testOne", genericSignature: "T: NSObject") {
                statement("print(\"Hello, World\")")
            }
            end()
        }
        
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    func testFuncWithArgs() {
        let example: String = """
                             func repeat(content: String, count: Int) {
                                 print(String(repeating: content, count: count))
                             }

                             """
        let docString: String = generateString {
            function(
                "repeat",
                arguments: [
                    Function.Argument(name: "content", type: "String"),
                    Function.Argument(name: "count", type: "Int")
                ]
            ) {
                statement("print(String(repeating: content, count: count))")
            }
            end()
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    func testFuncWithReturnValue() {
        let example: String = """
                             func this() -> (Int, String) {
                                 print(String(repeating: content, count: count))
                             }

                             """
        let docString: String = generateString {
            function("this", returnValue: "(Int, String)") {
                statement("print(String(repeating: content, count: count))")
            }
            end()
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    func testFuncAll() {
        let example: String = """
                             private static func transform<T: NSObject>(object: NSObject, transform: (NSObject) -> T) -> T {
                                 let newObject: T = transform(object)
                                 return newObject
                             }

                             """
        let docString: String = generateString {
            function(
            "transform",
            access: .private,
            isStatic: true,
            genericSignature: "T: NSObject",
            arguments: [
                Function.Argument(name: "object", type: "NSObject"),
                Function.Argument(name: "transform", type: "(NSObject) -> T")
            ],
            returnValue: "T") {
                statement("let newObject: T = transform(object)")
                statement("return newObject")
            }
            end()
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    func testLongFuncAll() {
        let example: String = """
                             private static func transform<T: NSObject>(
                                 test1: String,
                                 test2: String,
                                 test3: String,
                                 test4: String,
                                 test5: String
                             ) -> String {
                                 return test1 + test2 + test3 + test4 + test5
                             }

                             """
        let docString: String = generateString {
            function(
            "transform",
            access: .private,
            isStatic: true,
            genericSignature: "T: NSObject",
            arguments: [
                Function.Argument(name: "test1", type: "String"),
                Function.Argument(name: "test2", type: "String"),
                Function.Argument(name: "test3", type: "String"),
                Function.Argument(name: "test4", type: "String"),
                Function.Argument(name: "test5", type: "String")
            ],
            returnValue: "String") {
                statement("return test1 + test2 + test3 + test4 + test5")
            }
            end()
        }

        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    static var allTests: [(String, (FunctionTests) -> () -> ())] = [
        ("testFunc", testFunc),
        ("testFuncWithOpenAccess", testFuncWithOpenAccess),
        ("testFuncWithPublicAccess", testFuncWithPublicAccess),
        ("testFuncWithInternalAccess", testFuncWithInternalAccess),
        ("testFuncWithFileprivateAccess", testFuncWithFileprivateAccess),
        ("testFuncWithPrivateAccess", testFuncWithPrivateAccess),
        ("testStaticFunc", testStaticFunc),
        ("testGenericFunc", testGenericFunc),
        ("testFuncWithArgs", testFuncWithArgs),
        ("testFuncWithReturnValue", testFuncWithReturnValue),
        ("testFuncAll", testFuncAll),
        ("testLongFuncAll", testLongFuncAll)
    ]

}
