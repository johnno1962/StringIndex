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
        str[.end-6] = "a"
        XCTAssertEqual(str, "Hello, Warld?!")
        str[.start+1] = "o"
        XCTAssertEqual(str[..<(.first(of: " "))], "Hollo,")
        XCTAssertEqual(str[(str.endIndex-2)...], "?!")

        for i in 1...str.count {
            XCTAssertEqual(str[str.index(str.endIndex, offsetBy: -i)],
                           str[str.endIndex-i])
        }

        str.insert(".", at: .end+0+0)
        XCTAssertEqual(str, "Hollo, Warld?!.")

        XCTAssertEqual(str[.start+2 ..< .end-2], "llo, Warld?")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
