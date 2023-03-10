//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import XCTest
@testable import ScreenshotScribbler

final class ColorTypeParserTests: XCTestCase {
    
    /// Test `encode` method.
    func testEncode() throws {
        let parser = ColorTypeParser()
        var value: ColorType
        var expected: String
        var result: String
        
        // color
        value = .solid(color: Color(red: 0, green: 128, blue: 255))
        expected = "#0080FF"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)
        
        // linear gradient
        value = .linearGradient(colors: [DefaultColor.CSS.white, DefaultColor.CSS.black], direction: .toBottomRight)
        expected = "linear-gradient(to-bottom-right, #FFFFFF, #000000)"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)
        
        // radial gradient
        value = .radialGradient(colors: [DefaultColor.CSS.white, DefaultColor.CSS.black], direction: .toTopLeft)
        expected = "radial-gradient(to-top-left, #FFFFFF, #000000)"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)
    }
    
    /// Test common `parse` method.
    func testParse() throws {
        let parser = ColorTypeParser()
        var result: ColorType
        var expected: ColorType
        let defaultDirection: Direction = .toBottom
        
        // color
        result = try parser.parse("#FFFFFF")
        expected = .solid(color: DefaultColor.CSS.white)
        XCTAssertEqual(result, expected)
        
        // gradient
        result = try parser.parse("linear-gradient(#000000,#FFFFFF)")
        expected = .linearGradient(colors: [DefaultColor.CSS.black, DefaultColor.CSS.white], direction: defaultDirection)
        XCTAssertEqual(result, expected)
        
        // unsupported
        XCTAssertThrowsError(try parser.parse("foo(#000000)"))
    }
    
    /// Test parsing to `ColorType.linearGradient` instances.
    func testLinearGradientParsing() throws {
        let parser = ColorTypeParser()
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
        let parser = ColorTypeParser()
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
        let parser = ColorTypeParser()
        
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

}
