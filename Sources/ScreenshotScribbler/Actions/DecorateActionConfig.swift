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

/// Extension that enables decoding partial data.
extension DecorateActionConfig {
    
    /// Initializes this instance by allowing to be decoded based on partial data.
    ///
    /// - Parameter decoder: The decoder.
    ///
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try container.decodeAndSetIfPresent(LayoutConfig.self, .layout) { decoded in self.layout = decoded }
        try container.decodeAndSetIfPresent(ScreenshotConfig.self, .screenshot) { decoded in self.screenshot = decoded }
        try container.decodeAndSetIfPresent(BackgroundConfig.self, .background) { decoded in self.background = decoded }
        try container.decodeAndSetIfPresent(CaptionConfig.self, .caption) { decoded in self.caption = decoded }
    }
}
