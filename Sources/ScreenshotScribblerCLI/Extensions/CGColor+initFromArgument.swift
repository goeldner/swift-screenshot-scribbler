//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics
import ScreenshotScribbler

extension CGColor {
    
    /// Creates a `CGColor` instance by parsing the given string argument.
    ///
    /// - Parameter argument: The string in format: `#AABBCC`.
    /// - Returns: The `CGColor` instance.
    /// - Throws: `RuntimeError` if string cannot be parsed.
    ///
    public static func initFromArgument(_ argument: String) throws -> CGColor {
        let parser = ColorParser()
        return try parser.parse(argument).CGColor
    }
}
