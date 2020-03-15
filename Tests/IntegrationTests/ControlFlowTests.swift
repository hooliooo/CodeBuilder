import XCTest
@testable import CodeBuilder

final class ControlFlowTest: XCTestCase {

    private func generateString(@CodeBuilder _ builder: () -> [Fragment]) -> String {
        fileSpec(indent: "    ", builder)
    }

    private func generateString(@CodeBuilder _ builder: () -> Fragment) -> String {
        fileSpec(indent: "    ", { [builder()] })
    }

    func testControlFlow() {
        let example: String = """
                              if word == "That" {
                                  print("Hello, \\(word)")
                              }

                              """
        let docString: String = generateString {
            beginControlFlow("if word == \"That\"") {
                statement("print(\"Hello, \\(word)\")")
            }
            end()
        }

        XCTAssertTrue(example == docString, "Both strings should equal each other")
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
            beginControlFlow("if string.isEmpty") {
                statement("print(\"string is empty\")")
            }
            elseControlFlow {
                statement("print(\"string is not empty\")")
            }
            end()
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
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
            beginControlFlow("if x == 0") {
                statement("print(\"x is 0\")")
            }
            elseIf("x == 1") {
                statement("print(\"x is 1\")")
            }
            end()
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
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
            beginControlFlow("if x == 0") {
                statement("print(\"x is 0\")")
            }
            elseIf("x == 1") {
                statement("print(\"x is 1\")")
                statement("print(\"Hello, World\")")
                lineBreak()
            }
            elseControlFlow {
                statement("print(\"x is not 0 or 1\")")
            }
            end()
        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    func testGuardSpec() {
        let example: String = """
                              guard x == 0 else {
                                  return
                              }

                              """
        let docString: String = generateString {
            guardSpec(
                statement: {
                    statement("x == 0")
                },
                elseBlock: {
                    statement("return")
                }
            )

        }
        XCTAssertTrue(example == docString, "Both strings should equal each other")
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
        XCTAssertTrue(example == docString, "Both strings should equal each other")
    }

    static var allTests: [(String, (ControlFlowTest) -> () -> ())] = [
        ("testControlFlow", testControlFlow),
        ("testControlFlowWithElse", testControlFlowWithElse),
        ("testControlFlowWithElseIf", testControlFlowWithElseIf),
        ("testControlFlowWithElseIfAndElse", testControlFlowWithElseIfAndElse),
        ("testGuardSpec", testGuardSpec),
        ("testGuardSpecMultiline", testGuardSpecMultiline)
    ]

}
