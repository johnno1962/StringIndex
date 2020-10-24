import XCTest
@testable import StringIndex

final class StringIndexTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify
        // your tests produce the correct results.
        var str = "Hello, World!"
        str.insert("?", at: str.endIndex-1)
        XCTAssertEqual(str, "Hello, World?!")
        str[str.endIndex-6] = "a"
        XCTAssertEqual(str, "Hello, Warld?!")
        str[str.startIndex+1] = "o"
        XCTAssertEqual(str[..<(str.firstIndex(of: " ")+0)], "Hollo,")
        XCTAssertEqual(str[(str.endIndex-2)...], "?!")

        for i in 1...str.count {
            XCTAssertEqual(str[str.index(str.endIndex, offsetBy: -i)],
                           str[str.endIndex-i])
        }

        str.insert(".", at: str.endIndex+0+0)
        XCTAssertEqual(str, "Hollo, Warld?!.")

        XCTAssertEqual(str[str.startIndex+2 ..< str.endIndex-2], "llo, Warld?")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
