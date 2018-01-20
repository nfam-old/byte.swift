import XCTest
@testable import ByteTests

XCTMain([
    testCase(AlphabetTests.allTests),
    testCase(BytesTests.allTests),
    testCase(ByteTests.allTests),
    testCase(CharacterTests.allTests)
])
