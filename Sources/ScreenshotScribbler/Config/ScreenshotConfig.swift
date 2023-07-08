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

    /// Rotation of the screenshot. (Default: 0)
    public var screenshotRotation: Angle = .zero

    /// Public initializer.
    public init() {}

}

/// Extension that enables decoding partial data.
extension ScreenshotConfig {
    
    /// Initializes this instance by allowing to be decoded based on partial data.
    ///
    /// - Parameter decoder: The decoder.
    ///
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try container.decodeAndSetIfPresent(Double.self, .screenshotSizeFactor) { decoded in self.screenshotSizeFactor = decoded }
        try container.decodeAndSetIfPresent(Double.self, .screenshotCornerRadius) { decoded in self.screenshotCornerRadius = decoded }
        try container.decodeAndSetIfPresent(Double.self, .screenshotShadowSize) { decoded in self.screenshotShadowSize = decoded }
        try container.decodeAndSetIfPresent(Color.self, .screenshotShadowColor) { decoded in self.screenshotShadowColor = decoded }
        try container.decodeAndSetIfPresent(Double.self, .screenshotBorderSize) { decoded in self.screenshotBorderSize = decoded }
        try container.decodeAndSetIfPresent(ColorType.self, .screenshotBorderColor) { decoded in self.screenshotBorderColor = decoded }
        try container.decodeAndSetIfPresent(Angle.self, .screenshotRotation) { decoded in self.screenshotRotation = decoded }
    }
}
