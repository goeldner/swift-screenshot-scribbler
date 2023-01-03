//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

/// Types of one or more colors that may be drawn in different ways.
public enum ColorType {
    
    /// One solid color.
    case solid(color: CGColor)
    
    /// Multiple colors defining a linear gradient.
    case linearGradient(colors: [CGColor])
    
    /// Multiple colors defining a radial gradient.
    case radialGradient(colors: [CGColor])
    
}
