//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

/// Types of one or more colors that may be drawn in different ways.
public enum ColorType: Equatable {
    
    /// One solid color.
    case solid(color: CGColor)
    
    /// A linear gradient defined by multiple colors and a direction.
    case linearGradient(colors: [CGColor], direction: Direction)
    
    /// A radial gradient defined by multiple colors and a direction.
    case radialGradient(colors: [CGColor], direction: Direction)
    
}
