//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation

/// Background configuration
public struct BackgroundConfig: Equatable, Codable {
    
    /// Color which covers the whole background. (Default: white)
    public var backgroundColor: ColorType = .solid(color: DefaultColor.CSS.white)
    
    /// Scaling to apply to the background image, if image is defined. (Default: stretchFill)
    public var backgroundImageScaling: ImageScaling = .mode(.stretchFill)
    
    /// Alignment of the background image, if image is defined. (Default: center, middle)
    public var backgroundImageAlignment: Alignment = Alignment(horizontal: .center, vertical: .middle)
    
    /// Public initializer.
    public init() {}

}

/// Extension that enables decoding partial data.
extension BackgroundConfig {
    
    /// Initializes this instance by allowing to be decoded based on partial data.
    ///
    /// - Parameter decoder: The decoder.
    ///
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try container.decodeAndSetIfPresent(ColorType.self, .backgroundColor) { decoded in self.backgroundColor = decoded }
        try container.decodeAndSetIfPresent(ImageScaling.self, .backgroundImageScaling) { decoded in self.backgroundImageScaling = decoded }
        try container.decodeAndSetIfPresent(Alignment.self, .backgroundImageAlignment) { decoded in self.backgroundImageAlignment = decoded }
    }
}
