//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import XCTest
@testable import ScreenshotScribbler

final class AlignmentParserTests: XCTestCase {
    
    /// Test all horizontal strings.
    func testHorizontal() throws {
        let parser = AlignmentParser()
        var result: Alignment
        let defaultVertical = VerticalAlignment.middle
        
        result = try parser.parse("left")
        XCTAssertEqual(result.horizontal, .left)
        XCTAssertEqual(result.vertical, defaultVertical)
        
        result = try parser.parse("center")
        XCTAssertEqual(result.horizontal, .center)
        XCTAssertEqual(result.vertical, defaultVertical)
        
        result = try parser.parse("right")
        XCTAssertEqual(result.horizontal, .right)
        XCTAssertEqual(result.vertical, defaultVertical)
        
        // works also with surrounding whitespace
        result = try parser.parse("  right  ")
        XCTAssertEqual(result.horizontal, .right)
        XCTAssertEqual(result.vertical, defaultVertical)
    }
    
    /// Test all vertical strings.
    func testVertical() throws {
        let parser = AlignmentParser()
        var result: Alignment
        let defaultHorizontal = HorizontalAlignment.center
        
        result = try parser.parse("top")
        XCTAssertEqual(result.vertical, .top)
        XCTAssertEqual(result.horizontal, defaultHorizontal)
        
        result = try parser.parse("middle")
        XCTAssertEqual(result.vertical, .middle)
        XCTAssertEqual(result.horizontal, defaultHorizontal)
        
        result = try parser.parse("bottom")
        XCTAssertEqual(result.vertical, .bottom)
        XCTAssertEqual(result.horizontal, defaultHorizontal)
        
        // works also with surrounding whitespace
        result = try parser.parse("  bottom  ")
        XCTAssertEqual(result.vertical, .bottom)
        XCTAssertEqual(result.horizontal, defaultHorizontal)
    }
    
    /// Test some horizontal and vertical combinations.
    func testCombinations() throws {
        let parser = AlignmentParser()
        var result: Alignment
        
        result = try parser.parse("left top")
        XCTAssertEqual(result.horizontal, .left)
        XCTAssertEqual(result.vertical, .top)
        
        result = try parser.parse("center middle")
        XCTAssertEqual(result.horizontal, .center)
        XCTAssertEqual(result.vertical, .middle)
        
        result = try parser.parse("right bottom")
        XCTAssertEqual(result.horizontal, .right)
        XCTAssertEqual(result.vertical, .bottom)
        
        // works also with switched order
        result = try parser.parse("bottom right")
        XCTAssertEqual(result.horizontal, .right)
        XCTAssertEqual(result.vertical, .bottom)
        
        // works also with surrounding whitespace
        result = try parser.parse("  right  bottom  ")
        XCTAssertEqual(result.horizontal, .right)
        XCTAssertEqual(result.vertical, .bottom)
        
        // works also without whitespace
        result = try parser.parse("rightbottom")
        XCTAssertEqual(result.horizontal, .right)
        XCTAssertEqual(result.vertical, .bottom)
        
        // works also with empty string => defaults
        result = try parser.parse(" ")
        XCTAssertEqual(result.horizontal, .center)
        XCTAssertEqual(result.vertical, .middle)
    }
    
    /// Test invalid values.
    func testErrors() throws {
        let parser = AlignmentParser()
        
        XCTAssertThrowsError(try parser.parse(","))
        XCTAssertThrowsError(try parser.parse("-"))
        XCTAssertThrowsError(try parser.parse("foo"))
        XCTAssertThrowsError(try parser.parse("left foo"))
        XCTAssertThrowsError(try parser.parse("left-bottom"))
    }
}
