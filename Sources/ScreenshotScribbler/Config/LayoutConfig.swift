//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreText

/// Layout configuration
public struct LayoutConfig {
    
    /// Arrangement of the caption and screenshot. (Default: captionBeforeScreenshot)
    public var layoutType: LayoutType = .captionBeforeScreenshot
    
    /// Color which covers the whole background. (Default: white)
    public var backgroundColor: CGColor = white
    
    /// Percentage of the caption area height relative to the total height of the output image. (Default: 0.25 (25%))
    public var captionSizeFactor: CGFloat = 0.25
    
    /// Horizontal alignment of the caption. (Default: center)
    public var captionAlignment: CTTextAlignment = .center
    
    /// Color of the caption. (Default: black)
    public var captionColor: CGColor = black
    
    /// Font family name of the caption. (Default: "SF Compact")
    public var captionFontName: String = "SF Compact"
    
    /// Font style of the caption. (Default: "Bold")
    public var captionFontStyle: String = "Bold" // "Regular"
    
    /// Font size of the caption. (Default: 32)
    public var captionFontSize: Int = 32
    
    /// Percentage of the rendered screenshot size relative to its original size. (Default: 0.85 (85%))
    public var screenshotSizeFactor: CGFloat = 0.85
    
    /// Corner radius of the screenshot. (Default: 5)
    public var screenshotCornerRadius: CGFloat = 5
    
    /// Size of the shadow blur behind the screenshot. (Default: 5)
    public var screenshotShadowSize: CGFloat = 5
    
    /// Color of the shadow behind the screenshot. (Default: black)
    public var screenshotShadowColor: CGColor = black
    
    /// Size of the border around the screenshot. (Default: 0)
    public var screenshotBorderSize: CGFloat = 0
    
    /// Color of the border around the screenshot. (Default: black)
    public var screenshotBorderColor: CGColor = black
    
    /// White color, without using the CGColor.white shortcut, which is not available on iOS.
    private static let white = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    /// Black color, without using the CGColor.black shortcut, which is not available on iOS.
    private static let black = CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
    public init() {
    }
}
