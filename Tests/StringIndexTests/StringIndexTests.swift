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
        XCTAssertEqual(str[..<(.first(of:" "))], "Hollo,")
        XCTAssertEqual(str[(.last(of: " ")+1)...], "Warld?!.")

        let fifthChar: Character = str[.start+4]
        let firstWord = str[..<(.first(of:" "))]
        let stripped = str[.start+1 ..< .end-1]
        let lastWord = str[(.last(of: " ")+1)...]

        XCTAssertEqual(fifthChar, "o")
        XCTAssertEqual(firstWord, "Hollo,")
        XCTAssertEqual(stripped, "ollo, Warld?!")
        XCTAssertEqual(lastWord, "Warld?!.")

        str[..<(.first(of:" "))] = "Hi,"
        str[.first(of:"a")] = "o"
        XCTAssertEqual(str, "Hi, World?!.")
        XCTAssertEqual(str[(.last(of: " ")+1)...], "World?!.")

        XCTAssertNil(str[safe: .start-1])
        XCTAssertNil(str[safe: .end+1])
        XCTAssertNil(str[safe: .last(of: "🤠")])
        XCTAssertNil(str[safe: ..<(.first(of: "z"))])

        str[.end] = "🤡"
        XCTAssertEqual(str, "Hi, World?!.🤡")

    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
