//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
import ScreenshotScribbler

extension ColorType: ExpressibleByArgument {
    
    /// Creates a `ColorType` instance by parsing the given string argument.
    /// Returns `nil` if argument cannot be parsed by `ColorTypeParser`.
    ///
    /// - Parameter argument: The string to parse with `ColorTypeParser`.
    /// - Returns: The `ColorType` instance or `nil`.
    ///
    public init?(argument: String) {
        do {
            let parser = ColorTypeParser()
            self = try parser.parse(argument)
        } catch {
            return nil
        }
    }
}
