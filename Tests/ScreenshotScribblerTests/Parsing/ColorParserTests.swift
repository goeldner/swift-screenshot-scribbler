//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import XCTest
@testable import ScreenshotScribbler

final class ColorParserTests: XCTestCase {
    
    /// Test `encode` method with a `Color` instance.
    func testEncodeColor() throws {
        let parser = ColorParser()
        var value: Color
        var expected: String
        var result: String
        
        // color with default alpha
        value = Color(red: 0, green: 128, blue: 255)
        expected = "#0080FF"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)
        
        // color with custom alpha
        value = Color(red: 0, green: 128, blue: 255, alpha: 128)
        expected = "#0080FF80"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)
    }
    
    /// Test common `parse` method.
    func testParse() throws {
        let parser = ColorParser()
        var result: Color
        var expected: Color
        
        // color without alpha
        result = try parser.parse("#FFFFFF")
        expected = DefaultColor.CSS.white
        XCTAssertEqual(result, expected)
        
        // color with alpha
        result = try parser.parse("#FFFFFFFF")
        expected = DefaultColor.CSS.white
        XCTAssertEqual(result, expected)
        
        // color with custom values
        result = try parser.parse("#00204080")
        expected = Color(red: 0, green: 32, blue: 64, alpha: 128)
        XCTAssertEqual(result, expected)
        
        // unsupported
        XCTAssertThrowsError(try parser.parse("#1122334455"))
    }
    
    /// Test parsing to `Color` instances.
    func testHexColorParsing() throws {
        let parser = ColorParser()
        var value: String
        var result: Color
        var expected: Color
        
        // valid color (numbers)
        value = "#000000"
        XCTAssertTrue(parser.isHexColor(value))
        result = try parser.parseHexColor(value)
        expected = DefaultColor.CSS.black
        XCTAssertEqual(result, expected)
        
        // valid color (upper case)
        value = "#FFFFFF"
        XCTAssertTrue(parser.isHexColor(value))
        result = try parser.parseHexColor(value)
        expected = DefaultColor.CSS.white
        XCTAssertEqual(result, expected)
        
        // valid color (lower case)
        value = "#ffffff"
        XCTAssertTrue(parser.isHexColor(value))
        result = try parser.parseHexColor(value)
        expected = DefaultColor.CSS.white
        XCTAssertEqual(result, expected)
        
        // valid color (mixed case and numbers)
        value = "#ffA500"
        XCTAssertTrue(parser.isHexColor(value))
        result = try parser.parseHexColor(value)
        expected = Color(red: 255, green: 165, blue: 0) // ~= orange
        XCTAssertEqual(result, expected)
        
        // whitespace (prefix/suffix)
        value = "  #FFFFFF  "
        XCTAssertTrue(parser.isHexColor(value))
        result = try parser.parseHexColor(value)
        expected = DefaultColor.CSS.white
        XCTAssertEqual(result, expected)
        
        // whitespace (everywhere)
        value = "# FF FFF F"
        XCTAssertTrue(parser.isHexColor(value))
        result = try parser.parseHexColor(value)
        expected = DefaultColor.CSS.white
        XCTAssertEqual(result, expected)
    }
    
    /// Test invalid hex color values.
    func testHexColorParsingErrors() throws {
        let parser = ColorParser()
        
        // empty
        XCTAssertThrowsError(try parser.parseHexColor(""))
        XCTAssertThrowsError(try parser.parseHexColor(" "))
        
        // not 6 digits
        XCTAssertThrowsError(try parser.parseHexColor("#"))
        XCTAssertThrowsError(try parser.parseHexColor("#0"))
        XCTAssertThrowsError(try parser.parseHexColor("#00"))
        XCTAssertThrowsError(try parser.parseHexColor("#000"))
        XCTAssertThrowsError(try parser.parseHexColor("#0000"))
        XCTAssertThrowsError(try parser.parseHexColor("#00000"))
        
        // hashmark missing
        XCTAssertThrowsError(try parser.parseHexColor("000000"))
        
        // not hexadecimal
        XCTAssertThrowsError(try parser.parseHexColor("#G00000"))
        XCTAssertThrowsError(try parser.parseHexColor("#0G0000"))
        XCTAssertThrowsError(try parser.parseHexColor("#00G000"))
        XCTAssertThrowsError(try parser.parseHexColor("#000G00"))
        XCTAssertThrowsError(try parser.parseHexColor("#0000G0"))
        XCTAssertThrowsError(try parser.parseHexColor("#00000G"))
    }
}
