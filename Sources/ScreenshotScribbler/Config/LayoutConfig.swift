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

