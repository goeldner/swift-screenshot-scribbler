//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
import ScreenshotScribbler

extension ImageScaling: ExpressibleByArgument {
    
    /// Creates a `ImageScaling` instance by parsing the given string argument.
    /// Returns `nil` if argument cannot be parsed by `ImageScalingParser`.
    ///
    /// - Parameter argument: The string to parse with `ImageScalingParser`.
    /// - Returns: The `ImageScaling` instance or `nil`.
    ///
    public init?(argument: String) {
        do {
            let parser = ImageScalingParser()
            self = try parser.parse(argument)
        } catch {
            return nil
        }
    }
}
