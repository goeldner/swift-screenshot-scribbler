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
    public var backgroundColor: CGColor = CGColor.white
    
    /// Color of the rendered caption. (black by default)
    public var textColor: CGColor = CGColor.black
    
    /// Font family name. ("SF Compact" by default)
    public var fontName: String = "SF Compact"
    
    /// Font style. ("Bold" by default)
    public var fontStyle: String = "Bold" // "Regular"
    
    /// Font size. (32 by default)
    public var fontSize: Int = 32
    
    /// Size of the shadow blur. (5 by default)
    public var shadowSize: CGFloat = 5
    
    /// Color of the shadow. (black by default)
    public var shadowColor: CGColor = CGColor.black
    
    public init() {
    }
}
