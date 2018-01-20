import XCTest
@testable import Byte

class BytesTests: XCTestCase {
    static var allTests = [
        ("testStringError", testStringError),
        ("testNullInString", testNullInString),
        ("testEasyAppend", testEasyAppend),
        ("testAppend", testAppend),
        ("testInt", testInt),
        ("testIntError", testIntError),
        ("testStringConvertible", testStringConvertible)
    ]

    func testStringError() {
        // ✨ = [226, 156, 168]
        let bytes: Bytes = [226, 156]
        XCTAssertEqual(bytes.makeString(), "")
    }

    func testNullInString1() {
        let string1 = "a\u{0}b\u{0}\u{0}c"
        let bytes1 = string1.makeBytes()
        XCTAssertEqual(bytes1.makeString(), string1)
    }

    func testNullInString() {
        XCTAssertEqual("\u{1}\u{0}\u{2}".makeBytes(), [1, 0, 2])

        let string1 = "a\u{0}b\u{0}\u{0}c"
        let bytes1 = string1.makeBytes()
        XCTAssertEqual(bytes1, [0x61, 0, 0x62, 0, 0, 0x63])
        XCTAssertEqual(bytes1.makeString(), string1)

        let string2 = "\u{0}a\u{0}b\u{0}\u{0}c\u{0}"
        let bytes2 = string2.makeBytes()
        XCTAssertEqual(bytes2, [0, 0x61, 0, 0x62, 0, 0, 0x63, 0])
        XCTAssertEqual(bytes2.makeString(), string2)
    }

    func testEasyAppend() {
        var bytes: Bytes = [0x00]
        bytes += 0x42

        XCTAssertEqual(bytes, [0x00, 0x42])

        bytes += BytesSlice(arrayLiteral: 0x55, 0x6F)
        XCTAssertEqual(bytes, [0x00, 0x42, 0x55, 0x6F])
    }

    func testAppend() {
        var bytes: Bytes = []
        bytes.append(unicode: 0x41)
        XCTAssertEqual(bytes.count, 1)
        XCTAssertEqual(bytes, "A".makeBytes())
        bytes.removeAll()

        bytes.append(unicode: 0xED)
        XCTAssertEqual(bytes.count, 2)
        XCTAssertEqual(bytes, "í".makeBytes())
        bytes.removeAll()

        bytes.append(unicode: 0x0283)
        XCTAssertEqual(bytes.count, 2)
        XCTAssertEqual(bytes, "\u{0283}".makeBytes())
        bytes.removeAll()

        bytes.append(unicode: 0x4F8b)
        XCTAssertEqual(bytes.count, 3)
        XCTAssertEqual(bytes, "\u{4F8b}".makeBytes())
        bytes.removeAll()

        bytes.append(unicode: 0x1F425)
        XCTAssertEqual(bytes.count, 4)
        XCTAssertEqual(bytes, "\u{1F425}".makeBytes())
        bytes.removeAll()

        bytes.append(unicode: 0x10FFFF)
        XCTAssertEqual(bytes.count, 4)
        XCTAssertEqual(bytes, "\u{10FFFF}".makeBytes())
        bytes.removeAll()

        bytes.append(unicode: 0x3FFFFFF)
        XCTAssertEqual(bytes.count, 5)
        bytes.removeAll()

        bytes.append(unicode: 0x7FFFFFFF)
        XCTAssertEqual(bytes.count, 6)
        bytes.removeAll()

        bytes.append(unicode: 0x80000000)
        XCTAssertEqual(bytes.count, 0)
    }

    func testInt() {
        XCTAssertEqual(Byte.one.digit(radix: 2), 1)
        XCTAssertEqual(Int("aBf89".makeBytes(), radix: 16), 704393)
        XCTAssertEqual(Int("1337".makeBytes()), 1337)
        XCTAssertEqual(Int("+1337".makeBytes()), 1337)
        XCTAssertEqual(Int("-1337".makeBytes()), -1337)
    }

    func testIntError() {
        XCTAssertEqual(Byte.one.digit(radix: 1) as Int?, nil)
        XCTAssertEqual(Byte.one.digit(radix: 37) as Int?, nil)
        XCTAssertEqual(Int("-".makeBytes(), radix: 10), nil)
        XCTAssertEqual(Int("1337".makeBytes(), radix: 1), nil)
        XCTAssertEqual(Int("1337".makeBytes(), radix: 2), nil)
        XCTAssertEqual(Int("1337".makeBytes(), radix: 37), nil)
        XCTAssertEqual(Int("13ferret37".makeBytes()), nil)
        XCTAssertEqual(Int("9999999999999999999999999999999999".makeBytes()), nil)
    }

    func testStringConvertible() throws {
        let bytes: Bytes = [0x64, 0x65]
        let string = String(bytes: bytes)
        XCTAssertEqual(string.makeBytes(), bytes)

        let representable = string as BytesRepresentable
        let s = try String(bytes: representable)
        XCTAssertEqual(string, s)
    }

    func testStringPerformance() {
        let bytes = Bytes(repeating: 65, count: 65_536)
        measure {
            _ = bytes.makeString()
        }
    }
}
