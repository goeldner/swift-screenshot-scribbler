//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import XCTest
@testable import ScreenshotScribbler

final class DecorateActionConfigTests: XCTestCase {
    
    let defaultsJSON =
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
    
    let oneSettingJSON =
        """
        {
          "layout" : {
            "layoutType" : "screenshot-only"
          }
        }
        """
    
    let emptySectionsJSON =
        """
        {
          "screenshot" : {
          },
          "background" : {
          },
          "caption" : {
          },
          "layout" : {
          }
        }
        """
    
    let emptyJSON =
        """
        {
        }
        """
    
    /// Test encoding of default settings to JSON.
    func testEncodeDefaultSettingsToJSON() throws {
        
        // the config to encode
        let config = DecorateActionConfig()
        
        // the expected JSON
        let expected = defaultsJSON
        
        // encode and check
        let jsonString = try config.toJSON().toString()
        XCTAssertEqual(jsonString, expected)
    }
    
    /// Test decoding of default settings from JSON.
    func testDecodeDefaultSettingsFromCompletelyFilledJSON() throws {
        
        // the JSON to decode
        let jsonString = defaultsJSON
        let jsonData = jsonString.data(using: .utf8)!
        
        // the expected config
        let expected = DecorateActionConfig()
        
        // decode and check
        let config = try DecorateActionConfig(fromJSON: jsonData)
        XCTAssertEqual(config, expected)
    }
    
    /// Test decoding of JSON with empty sections.
    /// Should result into default settings because no value is overridden by JSON.
    func testDecodeDefaultSettingsFromEmptySectionsJSON() throws {
        
        // the JSON to decode
        let jsonString = emptySectionsJSON
        let jsonData = jsonString.data(using: .utf8)!
        
        // the expected config
        let expected = DecorateActionConfig()
        
        // decode and check
        let config = try DecorateActionConfig(fromJSON: jsonData)
        XCTAssertEqual(config, expected)
    }
    
    /// Test decoding of empty JSON.
    /// Should result into default settings because nothing is overridden by JSON.
    func testDecodeDefaultSettingsFromEmptyJSON() throws {
        
        // the JSON to decode
        let jsonString = emptyJSON
        let jsonData = jsonString.data(using: .utf8)!
        
        // the expected config
        let expected = DecorateActionConfig()
        
        // decode and check
        let config = try DecorateActionConfig(fromJSON: jsonData)
        XCTAssertEqual(config, expected)
    }
    
    /// Test decoding of JSON with one custom setting defined.
    /// Should result into default settings, except the one value that is overwritten.
    func testDecodeDefaultSettingsFromOneSettingJSON() throws {
        
        // the JSON to decode
        let jsonString = oneSettingJSON
        let jsonData = jsonString.data(using: .utf8)!
        
        // the expected config
        var expected = DecorateActionConfig()
        expected.layout.layoutType = .screenshotOnly
        
        // decode and check
        let config = try DecorateActionConfig(fromJSON: jsonData)
        XCTAssertEqual(config, expected)
    }
    
}
