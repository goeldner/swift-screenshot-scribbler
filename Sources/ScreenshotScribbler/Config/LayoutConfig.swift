//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

/// Layout configuration
public struct LayoutConfig {
    
    /// Arrangement of the caption and screenshot. (Default: captionBeforeScreenshot)
    public var layoutType: LayoutType = .captionBeforeScreenshot
    
    /// Public initializer.
    public init() {}

}

