import XCTest
@testable import Slisp

final class SlispTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Slisp().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
