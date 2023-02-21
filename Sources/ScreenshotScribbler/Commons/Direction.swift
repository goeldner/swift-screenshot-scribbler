//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation

/// Horizontal, vertical and diagonal directions.
public enum Direction: String, CaseIterable {
    
    /// Horizontal **to right**.
    case toRight = "to-right"
    
    /// Horizontal **to left**.
    case toLeft = "to-left"
    
    /// Vertical **to bottom**.
    case toBottom = "to-bottom"
    
    /// Vertical **to top**.
    case toTop = "to-top"
    
    /// Diagonal **to bottom right**.
    case toBottomRight = "to-bottom-right"
    
    /// Diagonal **to bottom left**.
    case toBottomLeft = "to-bottom-left"
    
    /// Diagonal **to top right**.
    case toTopRight = "to-top-right"
    
    /// Diagonal **to top left**.
    case toTopLeft = "to-top-left"
    
}
