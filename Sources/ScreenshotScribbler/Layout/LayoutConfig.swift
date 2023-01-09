//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

/// Layout configuration
public struct LayoutConfig {
    
    /// Arrangement of the caption and screenshot. (Default: captionBeforeScreenshot)
    public var layoutType: LayoutType = .captionBeforeScreenshot
    
    /// Color which covers the whole background. (Default: white)
    public var backgroundColor: ColorType = .solid(color: DefaultColor.CSS.white)
    
    /// Scaling to apply to the background image, if image is defined. (Default: stretchFill)
    public var backgroundImageScaling: ImageScaling = .mode(.stretchFill)
    
    /// Alignment of the background image, if image is defined. (Default: center, middle)
    public var backgroundImageAlignment: Alignment = Alignment(horizontal: .center, vertical: .middle)
    
    /// Percentage of the caption area height relative to the total height of the output image. (Default: 0.25 (25%))
    public var captionSizeFactor: CGFloat = 0.25
    
    /// Horizontal alignment of the caption. (Default: center)
    public var captionAlignment: HorizontalTextAlignment = .center
    
    /// Color of the caption. (Default: black)
    public var captionColor: CGColor = DefaultColor.CSS.black
    
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
    public var screenshotShadowColor: CGColor = DefaultColor.CSS.black
    
    /// Size of the border around the screenshot. (Default: 0)
    public var screenshotBorderSize: CGFloat = 0
    
    /// Color of the border around the screenshot. (Default: black)
    public var screenshotBorderColor: ColorType = .solid(color: DefaultColor.CSS.black)
    
    /// Public initializer.
    public init() {
    }
}
