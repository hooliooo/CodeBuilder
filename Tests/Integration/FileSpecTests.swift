import XCTest
@testable import CodeBuilder
import Benchmark

final class FileSpecTests: XCTestCase {

    func generateFile() -> File {
        return fileSpec(fileName: "Test", indent: "    ") {
            documentationSpec("Test doc for Test")
            typeSpec("Test", type: .class, inheritingFrom: ["This", "That"]) {
                documentationSpec("Test doc2")
                StoredProperty(access: .public, isMutable: true, name: "testOne", type: "String", value: nil)
                lineBreak()
                StoredProperty(access: .public, isMutable: false, name: "testTwo", type: "Bool", value: nil)
                lineBreak()
                documentationSpec(
                    "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto.",
                    format: .multiline,
                    parameters: [
                        Parameter(name: "testOne", documentation: "This is so cool"),
                        Parameter(name: "testTwo", documentation: "This is so cool"),
                        Parameter(name: "testThree", documentation: "This is so cool")
                    ],
                    returns: "String",
                    tag: "testDoc"
                )
                lineBreak()
                typeSpec("Test2", type: .struct) {
                    documentationSpec("Test doc4")
                    StoredProperty(access: .internal, isMutable: false, name: "testOne", type: "Bool", value: nil)
                    lineBreak()
                    documentationSpec(
                        "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto.",
                        format: .singleLine,
                        parameters: [
                            Parameter(name: "testOne", documentation: "This is so cool"),
                            Parameter(name: "testTwo", documentation: "This is so cool"),
                            Parameter(name: "testThree", documentation: "This is so cool")
                        ],
                        returns: "String",
                        tag: "testDoc"
                    )
                    functionSpec(
                        "test",
                        arguments: [
                            Argument(name: "testOne", type: "String")
                        ],
                        returnValue: "String",
                        {
                            statement(#"let t: String = "Hello, \(testOne)""#)
                            statement("return t")
                        }
                    )
                    lineBreak()
                    rawSpec(
                        """
                       class Test {
                           private init() {

                           }

                           func testOne() {
                               print(\"Hello, World\")
                           }

                           enum TestTwo {
                               case one
                               case two
                           }
                       }
                       """
                    )

                }
            }
        }
    }

    func testFileString() {

        let content: String = """
                             /// Test doc for Test
                             class Test: This, That {

                                 /// Test doc2
                                 public var testOne: String

                                 public let testTwo: Bool

                                 /**
                                  Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae
                                  ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque
                                  laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste
                                  natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi
                                  - parameters:
                                     - testOne: This is so cool
                                     - testTwo: This is so cool
                                     - testThree: This is so cool
                                  - returns: String
                                  - Tag: testDoc
                                  */

                                 struct Test2 {

                                     /// Test doc4
                                     let testOne: Bool

                                     /// Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa
                                     /// quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque
                                     /// laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste
                                     /// natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi
                                     /// - parameters:
                                     ///    - testOne: This is so cool
                                     ///    - testTwo: This is so cool
                                     ///    - testThree: This is so cool
                                     /// - returns: String
                                     /// - Tag: testDoc
                                     func test(testOne: String) -> String {
                                         let t: String = "Hello, \\(testOne)"
                                         return t
                                     }

                                     class Test {
                                         private init() {

                                         }

                                         func testOne() {
                                             print(\"Hello, World\")
                                         }

                                         enum TestTwo {
                                             case one
                                             case two
                                         }
                                     }
                                 }
                             }

                             """
        XCTAssert(content == generateFile().string, "content should equal the file's content")
    }

    func testFileDescription() {
        let file: File = generateFile()
        let content: String = """
                             File name: Test.swift
                             File contents:
                             /// Generated code by CodeBuilder on \(File.formatter.string(from: file.date)) - DO NOT EDIT!

                             /// Test doc for Test
                             class Test: This, That {

                                 /// Test doc2
                                 public var testOne: String

                                 public let testTwo: Bool

                                 /**
                                  Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae
                                  ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque
                                  laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste
                                  natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi
                                  - parameters:
                                     - testOne: This is so cool
                                     - testTwo: This is so cool
                                     - testThree: This is so cool
                                  - returns: String
                                  - Tag: testDoc
                                  */

                                 struct Test2 {

                                     /// Test doc4
                                     let testOne: Bool

                                     /// Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa
                                     /// quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque
                                     /// laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto. Sed ut perspiciatis unde omnis iste
                                     /// natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi
                                     /// - parameters:
                                     ///    - testOne: This is so cool
                                     ///    - testTwo: This is so cool
                                     ///    - testThree: This is so cool
                                     /// - returns: String
                                     /// - Tag: testDoc
                                     func test(testOne: String) -> String {
                                         let t: String = "Hello, \\(testOne)"
                                         return t
                                     }

                                     class Test {
                                         private init() {

                                         }

                                         func testOne() {
                                             print(\"Hello, World\")
                                         }

                                         enum TestTwo {
                                             case one
                                             case two
                                         }
                                     }
                                 }
                             }

                             """
        XCTAssert(file.description == content, "The file's description should equal the content")
    }

    func testWriteFile() {
        let file: File = generateFile()

        XCTAssertNoThrow(try file.write())
        let url: URL = URL(string: FileManager.default.currentDirectoryPath)!
        let fileURL: URL = url.appendingPathComponent(file.name).appendingPathExtension("swift")
        XCTAssertTrue(FileManager.default.fileExists(atPath: fileURL.path))

    }

    static var allTests: [(String, (FileSpecTests) -> () -> Void)] = [
        ("generateFile", testFileString),
        ("testFileDescription", testFileDescription),
        ("testWriteFile", testWriteFile)
    ]
}
