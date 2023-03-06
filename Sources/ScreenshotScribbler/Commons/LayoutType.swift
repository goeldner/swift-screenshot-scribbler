//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation

/// Different types of layout arrangements, i.e. how the caption and the screenshot are ordered.
public enum LayoutType: String, CaseIterable {
    
    /// Caption first, then screenshot
    case captionBeforeScreenshot = "caption-before-screenshot"
    
    /// Screenshot first, then caption.
    case captionAfterScreenshot = "caption-after-screenshot"
    
    /// One half of the screenshot first, then caption, then other half of the screenshot.
    case captionBetweenScreenshots = "caption-between-screenshots"
    
    /// Screenshot only, omitting any caption.
    case screenshotOnly = "screenshot-only"
    
}
