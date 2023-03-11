//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation

/// Screenshot configuration
public struct ScreenshotConfig: Equatable, Codable {
    
    /// Percentage of the rendered screenshot size relative to its original size. (Default: 0.85 (85%))
    public var screenshotSizeFactor: Double = 0.85
    
    /// Corner radius of the screenshot. (Default: 5)
    public var screenshotCornerRadius: Double = 5
    
    /// Size of the shadow blur behind the screenshot. (Default: 5)
    public var screenshotShadowSize: Double = 5
    
    /// Color of the shadow behind the screenshot. (Default: black)
    public var screenshotShadowColor: Color = DefaultColor.CSS.black
    
    /// Size of the border around the screenshot. (Default: 0)
    public var screenshotBorderSize: Double = 0
    
    /// Color of the border around the screenshot. (Default: black)
    public var screenshotBorderColor: ColorType = .solid(color: DefaultColor.CSS.black)
    
    /// Public initializer.
    public init() {}

}
