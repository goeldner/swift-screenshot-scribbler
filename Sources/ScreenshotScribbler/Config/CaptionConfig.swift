//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation

/// Caption configuration
public struct CaptionConfig {
    
    /// Percentage of the caption area height relative to the total height of the output image. (Default: 0.25 (25%))
    public var captionSizeFactor: Double = 0.25
    
    /// Horizontal alignment of the caption. (Default: center)
    public var captionAlignment: HorizontalTextAlignment = .center
    
    /// Color of the caption. (Default: black)
    public var captionColor: ColorType = .solid(color: DefaultColor.CSS.black)
    
    /// Font family name of the caption. (Default: "SF Compact")
    public var captionFontName: String = "SF Compact"
    
    /// Font style of the caption. (Default: "Bold")
    public var captionFontStyle: String = "Bold" // "Regular"
    
    /// Font size of the caption. (Default: 32)
    public var captionFontSize: Int = 32
    
    /// Public initializer.
    public init() {}

}
