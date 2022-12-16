//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

/// Layout configuration
public struct LayoutConfig {
    
    /// Arrangement of the caption and the screenshot.
    public var layoutType: LayoutType = .textBeforeImage
    
    /// Amount of the text area in vertical direction. (25% by default)
    public var textAreaRatio: CGFloat = 0.25
    
    /// Percentage of the screenshot in reduced size. (85% by default)
    public var imageSizeReduction: CGFloat = 0.85
    
    /// Color which covers the whole background. (white by default)
    public var backgroundColor: CGColor = white
    
    /// Color of the rendered caption. (black by default)
    public var textColor: CGColor = black
    
    /// Font family name. ("SF Compact" by default)
    public var fontName: String = "SF Compact"
    
    /// Font style. ("Bold" by default)
    public var fontStyle: String = "Bold" // "Regular"
    
    /// Font size. (32 by default)
    public var fontSize: Int = 32
    
    /// Size of the shadow blur. (5 by default)
    public var shadowSize: CGFloat = 5
    
    /// Color of the shadow. (black by default)
    public var shadowColor: CGColor = black
    
    /// White color, without using the CGColor.white shortcut, which is not available on iOS.
    private static let white = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    /// Black color, without using the CGColor.black shortcut, which is not available on iOS.
    private static let black = CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
    public init() {
    }
}
