//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
import ScreenshotScribbler

extension Alignment: ExpressibleByArgument {
    
    /// Creates an `Alignment` instance by parsing the given string argument.
    /// Returns `nil` if argument cannot be parsed by `AlignmentParser`.
    ///
    /// - Parameter argument: The string to parse with `AlignmentParser`.
    /// - Returns: The `Alignment` instance or `nil`.
    ///
    public init?(argument: String) {
        do {
            let parser = AlignmentParser()
            self = try parser.parse(argument)
        } catch {
            return nil
        }
    }
}
