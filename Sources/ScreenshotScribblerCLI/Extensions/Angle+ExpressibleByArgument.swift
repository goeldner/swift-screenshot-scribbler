//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
import ScreenshotScribbler

extension Angle: ExpressibleByArgument {

    /// Creates an `Angle` instance by parsing the given string argument.
    /// Returns `nil` if argument cannot be parsed by `AngleParser`.
    ///
    /// - Parameter argument: The string to parse with `AngleParser`.
    /// - Returns: The `Angle` instance or `nil`.
    ///
    public init?(argument: String) {
        do {
            let parser = AngleParser()
            self = try parser.parse(argument)
        } catch {
            return nil
        }
    }
}
