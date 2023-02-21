//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import XCTest
@testable import ScreenshotScribbler

final class ColorParserTests: XCTestCase {
    
    /// Test parsing to `ColorType.linearGradient` instances.
    func testLinearGradientParsing() throws {
        let parser = ColorParser()
        var result: ColorType
        var expected: ColorType
        let defaultDirection: Direction = .toBottom
        
        // two colors
        result = try parser.parseGradient("linear-gradient(#000000,#FFFFFF)")
        expected = .linearGradient(colors: [DefaultColor.CSS.black, DefaultColor.CSS.white], direction: defaultDirection)
        XCTAssertEqual(result, expected)
        
        // two colors and direction
        result = try parser.parseGradient("linear-gradient(to-top-right,#000000,#FFFFFF)")
        expected = .linearGradient(colors: [DefaultColor.CSS.black, DefaultColor.CSS.white], direction: .toTopRight)
        XCTAssertEqual(result, expected)
        
        // more colors
        result = try parser.parseGradient("linear-gradient(#000000,#FFFFFF,#FF0000)")
        expected = .linearGradient(colors: [DefaultColor.CSS.black, DefaultColor.CSS.white, DefaultColor.CSS.red], direction: defaultDirection)
        XCTAssertEqual(result, expected)
        
        // whitespace
        result = try parser.parseGradient("linear-gradient ( #000000 , #FFFFFF ,  #FF0000  )")
        expected = .linearGradient(colors: [DefaultColor.CSS.black, DefaultColor.CSS.white, DefaultColor.CSS.red], direction: defaultDirection)
        XCTAssertEqual(result, expected)
        
        // whitespace and direction
        result = try parser.parseGradient("linear-gradient ( to-top-right , #000000 , #FFFFFF ,  #FF0000  )")
        expected = .linearGradient(colors: [DefaultColor.CSS.black, DefaultColor.CSS.white, DefaultColor.CSS.red], direction: .toTopRight)
        XCTAssertEqual(result, expected)
    }
    
    /// Test parsing to `ColorType.radialGradient` instances.
    func testRadialGradientParsing() throws {
        let parser = ColorParser()
        var result: ColorType
        var expected: ColorType
        let defaultDirection: Direction = .toBottom
        
        // two colors
        result = try parser.parseGradient("radial-gradient(#000000,#FFFFFF)")
        expected = .radialGradient(colors: [DefaultColor.CSS.black, DefaultColor.CSS.white], direction: defaultDirection)
        XCTAssertEqual(result, expected)
        
        // two colors and direction
        result = try parser.parseGradient("radial-gradient(to-top-right,#000000,#FFFFFF)")
        expected = .radialGradient(colors: [DefaultColor.CSS.black, DefaultColor.CSS.white], direction: .toTopRight)
        XCTAssertEqual(result, expected)
        
        // more colors
        result = try parser.parseGradient("radial-gradient(#000000,#FFFFFF,#FF0000)")
        expected = .radialGradient(colors: [DefaultColor.CSS.black, DefaultColor.CSS.white, DefaultColor.CSS.red], direction: defaultDirection)
        XCTAssertEqual(result, expected)
        
        // whitespace
        result = try parser.parseGradient("radial-gradient ( #000000 , #FFFFFF ,  #FF0000  )")
        expected = .radialGradient(colors: [DefaultColor.CSS.black, DefaultColor.CSS.white, DefaultColor.CSS.red], direction: defaultDirection)
        XCTAssertEqual(result, expected)
        
        // whitespace and direction
        result = try parser.parseGradient("radial-gradient ( to-top-right , #000000 , #FFFFFF ,  #FF0000  )")
        expected = .radialGradient(colors: [DefaultColor.CSS.black, DefaultColor.CSS.white, DefaultColor.CSS.red], direction: .toTopRight)
        XCTAssertEqual(result, expected)
    }
    
    /// Test invalid gradient values.
    func testGradientParsingErrors() throws {
        let parser = ColorParser()
        
        // empty
        XCTAssertThrowsError(try parser.parseGradient(""))
        XCTAssertThrowsError(try parser.parseGradient(" "))
        
        // not enough colors
        XCTAssertThrowsError(try parser.parseGradient("linear-gradient()"))
        XCTAssertThrowsError(try parser.parseGradient("linear-gradient(#000000)"))
        XCTAssertThrowsError(try parser.parseGradient("radial-gradient()"))
        XCTAssertThrowsError(try parser.parseGradient("radial-gradient(#000000)"))
        
        // unknown gradient
        XCTAssertThrowsError(try parser.parseGradient("foo-gradient(#000000,#FFFFFF)"))
        
        // unknown direction
        XCTAssertThrowsError(try parser.parseGradient("linear-gradient(to-foo,#000000,#FFFFFF)"))
        
        // syntax errors
        XCTAssertThrowsError(try parser.parseGradient("linear gradient(#000000,#FFFFFF)"))
        XCTAssertThrowsError(try parser.parseGradient("linear-gradient(#000000 #FFFFFF)"))
    }
    
    /// Test parsing to `CGColor` instances.
    func testHexColorParsing() throws {
        let parser = ColorParser()
        var result: CGColor
        var expected: CGColor
        
        // valid color (numbers)
        result = try parser.parseHexColor("#000000")
        expected = DefaultColor.CSS.black
        XCTAssertEqual(result, expected)
        
        // valid color (upper case)
        result = try parser.parseHexColor("#FFFFFF")
        expected = DefaultColor.CSS.white
        XCTAssertEqual(result, expected)
        
        // valid color (lower case)
        result = try parser.parseHexColor("#ffffff")
        expected = DefaultColor.CSS.white
        XCTAssertEqual(result, expected)
        
        // valid color (mixed case and numbers)
        result = try parser.parseHexColor("#ffA500")
        expected = CGColor(red: 1.0, green: (CGFloat(165) / CGFloat(255)), blue: 0.0, alpha: 1.0) // ~= orange
        XCTAssertEqual(result, expected)
        
        // whitespace (prefix/suffix)
        result = try parser.parseHexColor("  #FFFFFF  ")
        expected = DefaultColor.CSS.white
        XCTAssertEqual(result, expected)
        
        // whitespace (everywhere)
        result = try parser.parseHexColor("# FF FFF F")
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
