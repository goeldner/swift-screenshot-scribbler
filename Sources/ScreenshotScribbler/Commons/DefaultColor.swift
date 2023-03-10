//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation

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
        public static let black = Color(red: 0, green: 0, blue: 0)
        
        /// CSS gray #808080
        public static let gray = Color(red: 128, green: 128, blue: 128)
        
        /// CSS silver #c0c0c0
        public static let silver = Color(red: 192, green: 192, blue: 192)
        
        /// CSS white #ffffff
        public static let white = Color(red: 255, green: 255, blue: 255)
        
        /// CSS orange #ffA500
        public static let orange = Color(red: 255, green: 165, blue: 0)
        
        /// CSS red #ff0000
        public static let red = Color(red: 255, green: 0, blue: 0)
        
        /// CSS maroon #800000
        public static let maroon = Color(red: 128, green: 0, blue: 0)
        
        /// CSS yellow #ffff00
        public static let yellow = Color(red: 255, green: 255, blue: 0)
        
        /// CSS olive #808000
        public static let olive = Color(red: 128, green: 128, blue: 0)
        
        /// CSS lime #00ff00
        public static let lime = Color(red: 0, green: 255, blue: 0)
        
        /// CSS green #008000
        public static let green = Color(red: 0, green: 128, blue: 0)
        
        /// CSS aqua #00ffff
        public static let aqua = Color(red: 0, green: 255, blue: 255)
        
        /// CSS teal #008080
        public static let teal = Color(red: 0, green: 128, blue: 128)
        
        /// CSS blue #0000ff
        public static let blue = Color(red: 0, green: 0, blue: 255)
        
        /// CSS navy #000080
        public static let navy = Color(red: 0, green: 0, blue: 128)
        
        /// CSS fuchsia #ff00ff
        public static let fuchsia = Color(red: 255, green: 0, blue: 255)
        
        /// CSS purple #800080
        public static let purple = Color(red: 128, green: 0, blue: 128)
        
    }
}
