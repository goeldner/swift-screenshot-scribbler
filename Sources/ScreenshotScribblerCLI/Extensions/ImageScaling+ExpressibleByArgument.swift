//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
import ScreenshotScribbler

extension ImageScaling: ExpressibleByArgument {
    
    /// Creates a `ImageScaling` instance by parsing the given string argument.
    /// Returns `nil` if argument cannot be parsed to be either a factor (decimal number)
    /// or one of the predefined `ImageScalingMode` options.
    ///
    /// - Parameter argument: The string to parse.
    /// - Returns: The `ImageScaling` instance or `nil`.
    ///
    public init?(argument: String) {
        if let factor = Double(argument: argument) {
            self = .factor(factor)
        } else if let mode = ImageScalingMode(argument: argument) {
            self = .mode(mode)
        } else {
            return nil
        }
    }
}
