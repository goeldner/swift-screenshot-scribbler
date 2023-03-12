//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation

/// Layout configuration
public struct LayoutConfig: Equatable, Codable {
    
    /// Arrangement of the caption and screenshot. (Default: captionBeforeScreenshot)
    public var layoutType: LayoutType = .captionBeforeScreenshot
    
    /// Public initializer.
    public init() {}

}

/// Extension that enables decoding partial data.
extension LayoutConfig {
    
    /// Initializes this instance by allowing to be decoded based on partial data.
    ///
    /// - Parameter decoder: The decoder.
    ///
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try container.decodeAndSetIfPresent(LayoutType.self, .layoutType) { decoded in self.layoutType = decoded }
    }
}
