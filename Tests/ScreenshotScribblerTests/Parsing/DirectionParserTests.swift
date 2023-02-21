//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import XCTest
@testable import ScreenshotScribbler

final class DirectionParserTests: XCTestCase {
    
    /// Test all valid strings.
    func testValidDirections() throws {
        let parser = DirectionParser()
        var result: Direction
        
        result = try parser.parse("to-right")
        XCTAssertEqual(result, .toRight)
        XCTAssertTrue(parser.isDirection("to-right"))
        
        result = try parser.parse("to-left")
        XCTAssertEqual(result, .toLeft)
        XCTAssertTrue(parser.isDirection("to-left"))
        
        result = try parser.parse("to-bottom")
        XCTAssertEqual(result, .toBottom)
        XCTAssertTrue(parser.isDirection("to-bottom"))
        
        result = try parser.parse("to-top")
        XCTAssertEqual(result, .toTop)
        XCTAssertTrue(parser.isDirection("to-top"))
        
        result = try parser.parse("to-bottom-right")
        XCTAssertEqual(result, .toBottomRight)
        XCTAssertTrue(parser.isDirection("to-bottom-right"))
        
        result = try parser.parse("to-bottom-left")
        XCTAssertEqual(result, .toBottomLeft)
        XCTAssertTrue(parser.isDirection("to-bottom-left"))
        
        result = try parser.parse("to-top-right")
        XCTAssertEqual(result, .toTopRight)
        XCTAssertTrue(parser.isDirection("to-top-right"))
        
        result = try parser.parse("to-top-left")
        XCTAssertEqual(result, .toTopLeft)
        XCTAssertTrue(parser.isDirection("to-top-left"))
    }
    
    /// Test some valid strings with whitespace in-between.
    func testValidDirectionsWithWhitespace() throws {
        let parser = DirectionParser()
        var result: Direction
        
        result = try parser.parse("to-right ")
        XCTAssertEqual(result, .toRight)
        XCTAssertTrue(parser.isDirection("to-right "))
        
        result = try parser.parse(" to-right")
        XCTAssertEqual(result, .toRight)
        XCTAssertTrue(parser.isDirection(" to-right"))
        
        result = try parser.parse(" to-right ")
        XCTAssertEqual(result, .toRight)
        XCTAssertTrue(parser.isDirection(" to-right "))
        
        result = try parser.parse("to - right")
        XCTAssertEqual(result, .toRight)
        XCTAssertTrue(parser.isDirection("to - right"))
    }
    
    /// Test invalid values. of `parse` method.
    func testErrorsParse() throws {
        let parser = DirectionParser()
        
        XCTAssertThrowsError(try parser.parse(""))
        XCTAssertThrowsError(try parser.parse(" "))
        XCTAssertThrowsError(try parser.parse("-"))
        XCTAssertThrowsError(try parser.parse("s"))
        XCTAssertThrowsError(try parser.parse("t"))
        XCTAssertThrowsError(try parser.parse("to"))
        XCTAssertThrowsError(try parser.parse("to-"))
        XCTAssertThrowsError(try parser.parse("to-foo"))
        XCTAssertThrowsError(try parser.parse("to-right-foo"))
        XCTAssertThrowsError(try parser.parse("to-right to-left"))
        XCTAssertThrowsError(try parser.parse("right"))
    }
    
    /// Test invalid values. of `isDirection` method.
    func testErrorsIsDirection() throws {
        let parser = DirectionParser()
        
        XCTAssertFalse(parser.isDirection(""))
        XCTAssertFalse(parser.isDirection(" "))
        XCTAssertFalse(parser.isDirection("-"))
        XCTAssertFalse(parser.isDirection("s"))
        XCTAssertFalse(parser.isDirection("t"))
        XCTAssertFalse(parser.isDirection("to"))
        XCTAssertFalse(parser.isDirection("to-"))
        XCTAssertFalse(parser.isDirection("to-foo"))
        XCTAssertFalse(parser.isDirection("to-right-foo"))
        XCTAssertFalse(parser.isDirection("to-right to-left"))
        XCTAssertFalse(parser.isDirection("right"))
    }
    
}
