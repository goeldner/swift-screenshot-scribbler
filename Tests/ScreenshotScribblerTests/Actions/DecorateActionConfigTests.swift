//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import XCTest
@testable import ScreenshotScribbler

final class DecorateActionConfigTests: XCTestCase {
    
    let defaultConfigJSON =
        """
        {
          "screenshot" : {
            "screenshotSizeFactor" : 0.84999999999999998,
            "screenshotShadowSize" : 5,
            "screenshotShadowColor" : "#000000",
            "screenshotBorderSize" : 0,
            "screenshotBorderColor" : "#000000",
            "screenshotCornerRadius" : 5
          },
          "background" : {
            "backgroundImageScaling" : "stretch-fill",
            "backgroundColor" : "#FFFFFF",
            "backgroundImageAlignment" : "middle center"
          },
          "caption" : {
            "captionAlignment" : "center",
            "captionColor" : "#000000",
            "captionFontName" : "SF Compact",
            "captionFontStyle" : "Bold",
            "captionFontSize" : 32,
            "captionSizeFactor" : 0.25
          },
          "layout" : {
            "layoutType" : "caption-before-screenshot"
          }
        }
        """
    
    /// Test encoding to JSON.
    func testEncodableJSON() throws {
        
        // the config to encode
        let config = DecorateActionConfig()
        
        // the expected JSON
        let expected = defaultConfigJSON
        
        // encode and check
        let jsonString = try config.toJSON().toString()
        XCTAssertEqual(jsonString, expected)
    }
    
    /// Test decoding from JSON.
    func testDecodableJSON() throws {
        
        // the JSON to decode
        let jsonString = defaultConfigJSON
        let jsonData = jsonString.data(using: .utf8)!
        
        // the expected config
        let expected = DecorateActionConfig()
        
        // decode and check
        let config = try DecorateActionConfig(fromJSON: jsonData)
        XCTAssertEqual(config, expected)
    }
    
}
