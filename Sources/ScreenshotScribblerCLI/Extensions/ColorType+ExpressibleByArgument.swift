//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
import ScreenshotScribbler

extension ColorType: ExpressibleByArgument {
    
    /// Creates a `ColorType` instance by parsing the given string argument.
    /// Returns `nil` if argument cannot be parsed by `ColorParser`.
    ///
    /// - Parameter argument: The string to parse with `ColorParser`.
    /// - Returns: The `ColorType` instance or `nil`.
    ///
    public init?(argument: String) {
        do {
            let colorParser = ColorParser()
            if colorParser.isHexColor(argument) {
                self = .solid(color: try colorParser.parseHexColor(argument))
            } else if colorParser.isGradient(argument) {
                self = try colorParser.parseGradient(argument)
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
