//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

/// Collection of default color values.
public struct DefaultColor {
    
    ///
    /// Default colors according to CSS 2.1 specification.
    /// See https://www.w3.org/TR/CSS21/syndata.html#color-units
    ///
    /// These are also the 16 safe colors of the HTML 4.01 specification (excluding orange).
    /// See https://www.w3.org/TR/REC-html40/types.html#h-6.5
    ///
    public struct CSS {
        
        /// CSS black #000000
        public static let black = CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        /// CSS gray #808080
        public static let gray = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        
        /// CSS silver #c0c0c0
        public static let silver = CGColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        
        /// CSS white #ffffff
        public static let white = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        /// CSS orange #ffA500
        public static let orange = CGColor(red: 1.0, green: 0.65, blue: 0.0, alpha: 1.0)
        
        /// CSS red #ff0000
        public static let red = CGColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        /// CSS maroon #800000
        public static let maroon = CGColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1.0)
        
        /// CSS yellow #ffff00
        public static let yellow = CGColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
        
        /// CSS olive #808000
        public static let olive = CGColor(red: 0.5, green: 0.5, blue: 0.0, alpha: 1.0)
        
        /// CSS lime #00ff00
        public static let lime = CGColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        
        /// CSS green #008000
        public static let green = CGColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        
        /// CSS aqua #00ffff
        public static let aqua = CGColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        /// CSS teal #008080
        public static let teal = CGColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 1.0)
        
        /// CSS blue #0000ff
        public static let blue = CGColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        
        /// CSS navy #000080
        public static let navy = CGColor(red: 0.0, green: 0.0, blue: 0.5, alpha: 1.0)
        
        /// CSS fuchsia #ff00ff
        public static let fuchsia = CGColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0)
        
        /// CSS purple #800080
        public static let purple = CGColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0)
        
    }
}
