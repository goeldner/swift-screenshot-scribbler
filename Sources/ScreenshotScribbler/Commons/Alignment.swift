//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation

/// Contains settings for horizontal and vertical alignment.
public struct Alignment {
    
    /// The horizontal alignment.
    public let horizontal: HorizontalAlignment
    
    /// The vertical alignment.
    public let vertical: VerticalAlignment
    
    /// Creates a new instance with horizontal and vertical alignment.
    ///
    /// - Parameters:
    ///   - horizontal: The horizontal alignment.
    ///   - vertical: The vertical alignment.
    ///
    public init(horizontal: HorizontalAlignment, vertical: VerticalAlignment) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
}
