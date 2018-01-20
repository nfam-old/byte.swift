import XCTest
@testable import Byte

class ByteTests: XCTestCase {
    static let allTests = [
        ("testIsCases", testIsCases)
    ]

    public func testIsCases() {
        // white space
        XCTAssertEqual(" ".makeBytes().first?.isWhitespace, true)
        XCTAssertEqual("\n".makeBytes().first?.isWhitespace, true)
        XCTAssertEqual("\r".makeBytes().first?.isWhitespace, true)
        XCTAssertEqual("\t".makeBytes().first?.isWhitespace, true)
        XCTAssertEqual("=".makeBytes().first?.isWhitespace, false)

        // letters
        XCTAssertEqual("a".makeBytes().first?.isLetter, true)
        XCTAssertEqual("F".makeBytes().first?.isLetter, true)
        XCTAssertEqual("g".makeBytes().first?.isLetter, true)
        XCTAssertEqual("é".makeBytes().first?.isLetter, false)

        // digits
        for i in 0...9 {
            XCTAssertEqual(i.description.makeBytes().first?.isDigit, true)
            XCTAssertEqual(i.description.makeBytes().first?.isAlphanumeric, true)
        }
        XCTAssertEqual("f".makeBytes().first?.isDigit, false)

        // hex digits
        for character in "0123456789abcdefABCDEF" {
            XCTAssertEqual(String(character).makeBytes().first?.isHexDigit, true)
        }
        XCTAssertEqual("g".makeBytes().first?.isHexDigit, false)
    }
}
