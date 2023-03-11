//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation

///
/// Configuration settings that contol the appearance of the `decorate` action output.
///
public struct DecorateActionConfig: Equatable, Codable {
    
    /// Layout configuration.
    public var layout = LayoutConfig()
    
    /// Screenshot configuration.
    public var screenshot = ScreenshotConfig()
    
    /// Background configuration.
    public var background = BackgroundConfig()
    
    /// Caption configuration.
    public var caption = CaptionConfig()
    
    /// Public initializer.
    public init() {}

}
