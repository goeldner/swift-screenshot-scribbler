//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

/// Extension providing convenience methods for working with `CGColor` instances.
public extension Color {
    
    /// Convenience access to a `CGColor` instance.
    var CGColor: CoreGraphics.CGColor {
        let r = CGFloat(red) / 255
        let g = CGFloat(green) / 255
        let b = CGFloat(blue) / 255
        let a = CGFloat(alpha) / 255
        return CoreGraphics.CGColor(red: r, green: g, blue: b, alpha: a)
    }
    
    /// Public initializer based on a `CGColor` instance.
    ///
    /// - Parameter color: The `CGColor` instance.
    ///
    init(_ color: CoreGraphics.CGColor) {
        let r = Int(round(color.components![0] * 255))
        let g = Int(round(color.components![1] * 255))
        let b = Int(round(color.components![2] * 255))
        let a = color.numberOfComponents > 3 ? Int(round(color.components![3] * 255)) : 255
        self = Color(red: r, green: g, blue: b, alpha: a)
    }
}
