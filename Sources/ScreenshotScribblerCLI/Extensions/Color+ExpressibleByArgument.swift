//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
import ScreenshotScribbler

extension Color: ExpressibleByArgument {
    
    /// Creates a `Color` instance by parsing the given string argument.
    /// Returns `nil` if argument cannot be parsed by `ColorParser`.
    ///
    /// - Parameter argument: The string to parse with `ColorParser`.
    /// - Returns: The `Color` instance or `nil`.
    ///
    public init?(argument: String) {
        do {
            let parser = ColorParser()
            self = try parser.parse(argument)
        } catch {
            return nil
        }
    }
}
