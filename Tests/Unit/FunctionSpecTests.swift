import XCTest
@testable import CodeBuilder

final class FunctionSpecTests: XCTestCase {

    private func generateString(@CodeBuilder _ builder: () -> CodeRepresentable) -> String {
        fileSpec(fileName: "", indent: "    ", builder).string
    }

    func testFunc() {
        let example: String = """
                             func testOne() {
                                 print(\"Hello, World\")
                             }

                             """
        let docString: String = generateString {
            functionSpec("testOne") {
                statement("print(\"Hello, World\")")
            }
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testFuncWithOpenAccess() {
        let example: String = """
                             open func testOne() {
                                 print(\"Hello, World\")
                             }

                             """
        let docString: String = generateString {
            functionSpec("testOne", access: .open) {
                statement("print(\"Hello, World\")")
            }
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testFuncWithPublicAccess() {
        let example: String = """
                             public func testOne() {
                                 print(\"Hello, World\")
                             }

                             """
        let docString: String = generateString {
            functionSpec("testOne", access: .public) {
                statement("print(\"Hello, World\")")
            }
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testFuncWithInternalAccess() {
        let example: String = """
                             func testOne() {
                                 print(\"Hello, World\")
                             }

                             """
        let docString: String = generateString {
            functionSpec("testOne", access: .internal) {
                statement("print(\"Hello, World\")")
            }
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testFuncWithFileprivateAccess() {
        let example: String = """
                             fileprivate func testOne() {
                                 print(\"Hello, World\")
                             }

                             """
        let docString: String = generateString {
            functionSpec("testOne", access: .fileprivate) {
                statement("print(\"Hello, World\")")
            }
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testFuncWithPrivateAccess() {
        let example: String = """
                             private func testOne() {
                                 print(\"Hello, World\")
                             }

                             """
        let docString: String = generateString {
            functionSpec("testOne", access: .private) {
                statement("print(\"Hello, World\")")
            }
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testStaticFunc() {
        let example: String = """
                             static func testOne() {
                                 print(\"Hello, World\")
                             }

                             """
        let docString: String = generateString {
            functionSpec("testOne", isStatic: true) {
                statement("print(\"Hello, World\")")
            }
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testAsyncFunc() {
        let example: String = """
                             func testOne() async {
                                 try? await Task.sleep(nanoseconds: 1_000_000_000)
                                 print(\"Hello, World\")
                             }

                             """
        let docString: String = generateString {
            functionSpec("testOne", keywords: [.async]) {
                statement("try? await Task.sleep(nanoseconds: 1_000_000_000)")
                statement("print(\"Hello, World\")")
            }
        }

        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testThrowingFunc() {
        let example: String = """
                             func testOne() throws {
                                 print(\"Hello, World\")
                             }

                             """
        let docString: String = generateString {
            functionSpec("testOne", keywords: [.throwing(.throws)]) {
                statement("print(\"Hello, World\")")
            }
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testThrowsRethrowsFunc() {
        let example: String = """
                              public func copy(with changes: (inout Self) throws -> Void) rethrows -> Self {
                                  var mutableSelf = self
                                  try changes(&mutableSelf)
                                  return mutableSelf
                              }

                              """
        let docString: String = generateString {
            functionSpec(
                "copy",
                access: Access.public,
                keywords: [.throwing(.rethrows)],
                arguments: [
                    Argument(name: "with changes", type: "(inout Self) throws -> Void")
                ],
                returnValue: "Self") {
                    statement("var mutableSelf = self")
                    statement("try changes(&mutableSelf)")
                    statement("return mutableSelf")
                }
        }

        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testAsyncThrowsFunc() {
        let example: String = """
                             func testOne() async throws {
                                 try await Task.sleep(nanoseconds: 1_000_000_000)
                                 print(\"Hello, World\")
                             }

                             """
        let docString: String = generateString {
            functionSpec("testOne", keywords: [.throwing(.throws), .async]) {
                statement("try await Task.sleep(nanoseconds: 1_000_000_000)")
                statement("print(\"Hello, World\")")
            }
        }

        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testThrowsRethrowsTogetherReturnsNone() {
        let example: String = ""
        let docString: String = generateString {
            functionSpec("testOne", keywords: [.throwing(.throws), .async, .throwing(.rethrows)]) {
                statement("try await Task.sleep(nanoseconds: 1_000_000_000)")
                statement("print(\"Hello, World\")")
            }
        }
        XCTAssertEqual(docString.isEmpty, example.isEmpty)
    }

    func testGenericFunc() {
        let example: String = """
                             func testOne<T: NSObject>() {
                                 print(\"Hello, World\")
                             }

                             """
        let docString: String = generateString {
            functionSpec("testOne", genericSignature: "T: NSObject") {
                statement("print(\"Hello, World\")")
            }
        }

        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testFuncWithArgs() {
        let example: String = """
                             func repeat(content: String, count: Int) {
                                 print(String(repeating: content, count: count))
                             }

                             """
        let docString: String = generateString {
            functionSpec(
                "repeat",
                arguments: [
                    Argument(name: "content", type: "String"),
                    Argument(name: "count", type: "Int")
                ]
            ) {
                statement("print(String(repeating: content, count: count))")
            }
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testFuncWithReturnValue() {
        let example: String = """
                             func this() -> (Int, String) {
                                 print(String(repeating: content, count: count))
                             }

                             """
        let docString: String = generateString {
            functionSpec("this", returnValue: "(Int, String)") {
                statement("print(String(repeating: content, count: count))")
            }
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testFuncAll() {
        let example: String = """
                             private static func transform<T: NSObject>(object: NSObject, transform: (NSObject) -> T) -> T {
                                 let newObject: T = transform(object)
                                 return newObject
                             }

                             """
        let docString: String = generateString {
            functionSpec(
                "transform",
                access: .private,
                isStatic: true,
                genericSignature: "T: NSObject",
                arguments: [
                    Argument(name: "object", type: "NSObject"),
                    Argument(name: "transform", type: "(NSObject) -> T")
                ],
                returnValue: "T"
            ) {
                statement("let newObject: T = transform(object)")
                statement("return newObject")
            }
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
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
            functionSpec(
            "transform",
            access: .private,
            isStatic: true,
            genericSignature: "T: NSObject",
            arguments: [
                Argument(name: "test1", type: "String"),
                Argument(name: "test2", type: "String"),
                Argument(name: "test3", type: "String"),
                Argument(name: "test4", type: "String"),
                Argument(name: "test5", type: "String")
            ],
            returnValue: "String") {
                statement("return test1 + test2 + test3 + test4 + test5")
            }
        }

        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    static var allTests: [(String, (FunctionSpecTests) -> () -> Void)] = [
        ("testFunc", testFunc),
        ("testFuncWithOpenAccess", testFuncWithOpenAccess),
        ("testFuncWithPublicAccess", testFuncWithPublicAccess),
        ("testFuncWithInternalAccess", testFuncWithInternalAccess),
        ("testFuncWithFileprivateAccess", testFuncWithFileprivateAccess),
        ("testFuncWithPrivateAccess", testFuncWithPrivateAccess),
        ("testStaticFunc", testStaticFunc),
        ("testAsyncFunc", testAsyncFunc),
        ("testThrowingFunc", testThrowingFunc),
        ("testThrowsRethrowsFunc", testThrowsRethrowsFunc),
        ("testAsyncThrowsFunc", testAsyncThrowsFunc),
        ("testGenericFunc", testGenericFunc),
        ("testFuncWithArgs", testFuncWithArgs),
        ("testFuncWithReturnValue", testFuncWithReturnValue),
        ("testFuncAll", testFuncAll),
        ("testLongFuncAll", testLongFuncAll)
    ]

}
