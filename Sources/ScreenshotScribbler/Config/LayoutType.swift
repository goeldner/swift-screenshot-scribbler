//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation

/// Differenty types of layout arrangements, i.e. how the caption and the screenshot are ordered.
public enum LayoutType: String {
    
    /// Caption on top, screenshot below.
    case textBeforeImage
    
    /// Screenshot on top, caption below.
    case textAfterImage
    
    /// Parts of the screenshot on top and bottom, caption between both.
    case textBetweenImages
    
}
