//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import XCTest
@testable import ScreenshotScribbler

final class AngleParserTests: XCTestCase {

    /// Test `encode` method with radians.
    func testEncodeRadians() throws {
        let parser = AngleParser()
        var value: Angle
        var expected: String
        var result: String

        // value without fraction
        value = Angle(radians: 42)
        expected = "42rad"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)

        // value with fraction
        value = Angle(radians: 3.14)
        expected = "3.14rad"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)

        // value with long fraction, rounded to 4 digits
        value = Angle(radians: 0.12345)
        expected = "0.1235rad"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)

        // negative value
        value = Angle(radians: -3.1415)
        expected = "-3.1415rad"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)
    }

    /// Test `encode` method with degrees.
    func testEncodeDegrees() throws {
        let parser = AngleParser()
        var value: Angle
        var expected: String
        var result: String

        // value without fraction
        value = Angle(degrees: 42)
        expected = "42deg"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)

        // value with fraction
        value = Angle(degrees: 3.14)
        expected = "3.14deg"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)

        // value with long fraction, rounded to 4 digits
        value = Angle(degrees: 0.12345)
        expected = "0.1235deg"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)

        // negative value
        value = Angle(degrees: -3.1415)
        expected = "-3.1415deg"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)
    }

    /// Test common `parse` method.
    func testParse() throws {
        let parser = AngleParser()
        var result: Angle
        var expected: Angle

        // radians
        result = try parser.parse("1.23456rad")
        expected = Angle(radians: 1.23456)
        XCTAssertEqual(result, expected)

        // radians with whitespace
        result = try parser.parse("1.23456   rad")
        expected = Angle(radians: 1.23456)
        XCTAssertEqual(result, expected)

        // degrees
        result = try parser.parse("1.23456deg")
        expected = Angle(degrees: 1.23456)
        XCTAssertEqual(result, expected)

        // degrees -> radians conversion
        result = try parser.parse("180deg")
        expected = Angle(radians: .pi)
        XCTAssertEqual(result, expected)

        // negative radians
        result = try parser.parse("-3.1415rad")
        expected = Angle(radians: -3.1415)
        XCTAssertEqual(result, expected)

        // negative degrees
        result = try parser.parse("-3.1415deg")
        expected = Angle(degrees: -3.1415)
        XCTAssertEqual(result, expected)

        // missing suffix
        XCTAssertThrowsError(try parser.parse("42"))

        // unsupported suffix
        XCTAssertThrowsError(try parser.parse("42foo"))
    }

    /// Test parsing and encoding of zero.
    func testZero() throws {
        let parser = AngleParser()

        // parse zero
        let angle = try parser.parse("0")
        XCTAssertEqual(angle, Angle.zero)

        // encode zero
        let string = parser.encode(.zero)
        XCTAssertEqual(string, "0")
    }
}
