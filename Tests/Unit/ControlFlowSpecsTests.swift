import XCTest
@testable import CodeBuilder

final class ControlFlowSpecTest: XCTestCase {

    private func generateString(@CodeBuilder _ builder: () -> CodeRepresentable) -> String {
        fileSpec(fileName: "", indent: "    ", builder).string
    }

    func testControlFlow() {
        let example: String = """
                              if word == "That" {
                                  print("Hello, \\(word)")
                              }

                              """
        let docString: String = generateString {
            controlFlowSpec("if word == \"That\"") {
                statement("print(\"Hello, \\(word)\")")
            }
            end()
        }

        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testControlFlowWithElse() {
        let example: String = """
                              if string.isEmpty {
                                  print(\"string is empty\")
                              } else {
                                  print(\"string is not empty\")
                              }

                              """
        let docString: String = generateString {
            controlFlowSpec("if string.isEmpty") {
                statement("print(\"string is empty\")")
            }
            elseSpec {
                statement("print(\"string is not empty\")")
            }
            end()
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testControlFlowWithElseIf() {
        let example: String = """
                              if x == 0 {
                                  print(\"x is 0\")
                              } else if x == 1 {
                                  print(\"x is 1\")
                              }

                              """
        let docString: String = generateString {
            controlFlowSpec("if x == 0") {
                statement("print(\"x is 0\")")
            }
            elseIfSpec("x == 1") {
                statement("print(\"x is 1\")")
            }
            end()
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testControlFlowWithElseIfAndElse() {
        let example: String = """
                              if x == 0 {
                                  print(\"x is 0\")
                              } else if x == 1 {
                                  print(\"x is 1\")
                                  print(\"Hello, World\")

                              } else {
                                  print(\"x is not 0 or 1\")
                              }

                              """
        let docString: String = generateString {
            controlFlowSpec("if x == 0") {
                statement("print(\"x is 0\")")
            }
            elseIfSpec("x == 1") {
                statement("print(\"x is 1\")")
                statement("print(\"Hello, World\")")
                lineBreak()
            }
            elseSpec {
                statement("print(\"x is not 0 or 1\")")
            }
            end()
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testGuardSpec() {
        let example: String = """
                              guard x == 0 else {
                                  return
                              }

                              """
        let docString: String = generateString {
            guardSpec(
                statements: {
                    statement("x == 0")
                },
                elseBlock: {
                    statement("return")
                }
            )

        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testGuardSpecMultiline() {
        let example: String = """
                              guard
                                  x == 0,
                                  y == 0
                              else {
                                  print("Bool failed")
                                  return
                              }

                              """
        let docString: String = generateString {
            guardSpec(
                statements: {
                    statement("x == 0")
                    statement("y == 0")
                },
                elseBlock: {
                    statement(
                        """
                       print("Bool failed")
                       """
                    )
                    statement("return")
                }
            )

        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testDoSpecMultiline() {
        let example: String = """
                              do {
                                  let realm = try Realm()
                                  print(realm)
                              }

                              """
        let docString: String = generateString {
            doSpec {
                statement("let realm = try Realm()")
                statement("print(realm)")
            }
            end()
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testDoSpecSingleline() {
        let example: String = """
                              do {
                                  let realm = try Realm()
                              }

                              """
        let docString: String = generateString {
            doSpec {
                statement("let realm = try Realm()")
            }
            end()
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testCatchSpecMultiline() {
        let example: String = """
                              } catch let error {
                                  print("failed")
                                  print(error.localziedDescription)
                              }

                              """
        let docString: String = generateString {
            catchSpec(statement: "let error") {
                statement(#"print("failed")"#)
                statement("print(error.localziedDescription)")
            }
            end()
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    func testCatchSpecSingleline() {
        let example: String = """
                              } catch let error {
                                  print("failed")
                              }

                              """
        let docString: String = generateString {
            catchSpec(statement: "let error") {
                statement(#"print("failed")"#)
            }
            end()
        }
        XCTAssertTrue(example == docString, self.message(expected: example, actual: docString))
    }

    static var allTests: [(String, (ControlFlowSpecTest) -> () -> Void)] = [
        ("testControlFlow", testControlFlow),
        ("testControlFlowWithElse", testControlFlowWithElse),
        ("testControlFlowWithElseIf", testControlFlowWithElseIf),
        ("testControlFlowWithElseIfAndElse", testControlFlowWithElseIfAndElse),
        ("testGuardSpec", testGuardSpec),
        ("testGuardSpecMultiline", testGuardSpecMultiline),
        ("testDoSpecMultiline", testDoSpecMultiline),
        ("testDoSpecSingleline", testDoSpecSingleline),
        ("testCatchSpecMultiline", testCatchSpecMultiline),
        ("testCatchSpecSingleline", testCatchSpecSingleline)
    ]

}
