//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation

/// Caption configuration
public struct CaptionConfig: Equatable, Codable {
    
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

/// Extension that enables decoding partial data.
extension CaptionConfig {
    
    /// Initializes this instance by allowing to be decoded based on partial data.
    ///
    /// - Parameter decoder: The decoder.
    ///
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try container.decodeAndSetIfPresent(Double.self, .captionSizeFactor) { decoded in self.captionSizeFactor = decoded }
        try container.decodeAndSetIfPresent(HorizontalTextAlignment.self, .captionAlignment) { decoded in self.captionAlignment = decoded }
        try container.decodeAndSetIfPresent(ColorType.self, .captionColor) { decoded in self.captionColor = decoded }
        try container.decodeAndSetIfPresent(String.self, .captionFontName) { decoded in self.captionFontName = decoded }
        try container.decodeAndSetIfPresent(String.self, .captionFontStyle) { decoded in self.captionFontStyle = decoded }
        try container.decodeAndSetIfPresent(Int.self, .captionFontSize) { decoded in self.captionFontSize = decoded }
    }
}
