//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

/// Background configuration
public struct BackgroundConfig {
    
    /// Color which covers the whole background. (Default: white)
    public var backgroundColor: ColorType = .solid(color: DefaultColor.CSS.white)
    
    /// Scaling to apply to the background image, if image is defined. (Default: stretchFill)
    public var backgroundImageScaling: ImageScaling = .mode(.stretchFill)
    
    /// Alignment of the background image, if image is defined. (Default: center, middle)
    public var backgroundImageAlignment: Alignment = Alignment(horizontal: .center, vertical: .middle)
    
    /// Public initializer.
    public init() {}

}
