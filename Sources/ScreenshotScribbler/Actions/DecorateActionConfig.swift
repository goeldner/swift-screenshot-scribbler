//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

/// Configuration of the `decorate` action.
public struct DecorateActionConfig {
    
    /// Layout configuration.
    public var layout = LayoutConfig()
    
    /// Screenshot configuration.
    public var screenshot = ScreenshotConfig()
    
    /// Caption configuration.
    public var caption = CaptionConfig()
    
    /// Background configuration.
    public var background = BackgroundConfig()
    
    /// Public initializer.
    public init() {}

}
