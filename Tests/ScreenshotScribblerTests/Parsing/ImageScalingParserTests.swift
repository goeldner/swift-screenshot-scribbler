//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import XCTest
@testable import ScreenshotScribbler

final class ImageScalingParserTests: XCTestCase {
    
    /// Test `encode` method.
    func testEncode() throws {
        let parser = ImageScalingParser()
        var value: ImageScaling
        var expected: String
        var result: String
        
        // factor without fraction
        value = .factor(42)
        expected = "42"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)
        
        // factor with fraction
        value = .factor(3.14)
        expected = "3.14"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)
        
        // factor with long fraction, rounded to 4 digits
        value = .factor(0.12345)
        expected = "0.1235"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)
        
        // mode: none
        value = .mode(.none)
        expected = "none"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)
        
        // mode: stretchFill
        value = .mode(.stretchFill)
        expected = "stretch-fill"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)
        
        // mode: aspectFill
        value = .mode(.aspectFill)
        expected = "aspect-fill"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)
        
        // mode: aspectFit
        value = .mode(.aspectFit)
        expected = "aspect-fit"
        result = parser.encode(value)
        XCTAssertEqual(result, expected)
    }
    
    /// Test common `parse` method.
    func testParse() throws {
        let parser = ImageScalingParser()
        var result: ImageScaling
        var expected: ImageScaling
        
        // factor
        result = try parser.parse("0.12345")
        expected = .factor(0.12345)
        XCTAssertEqual(result, expected)
        
        // mode: aspectFit
        result = try parser.parse("aspect-fit")
        expected = .mode(.aspectFit)
        XCTAssertEqual(result, expected)
        
        // unsupported
        XCTAssertThrowsError(try parser.parse("foo"))
    }

}
