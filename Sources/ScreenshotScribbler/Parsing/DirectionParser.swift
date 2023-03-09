//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation

///
/// Parser for direction strings.
///
public class DirectionParser {
 
    /// Matches a direction, e.g. "to-right", "to-top", "to-top-right" or "to-bottom-left"
    internal static let DirectionPattern = "to\\-(top|right|bottom|left|top\\-right|top\\-left|bottom\\-right|bottom\\-left)"
    
    /// Public initializer.
    public init() {}
    
    /// Parses the given string to a `Direction` if supported. Throws a `RuntimeError` otherwise.
    ///
    /// - Parameter string: The string to parse.
    /// - Returns: The parsed `Direction` instance.
    /// - Throws: `RuntimeError` if string cannot be parsed successfully for any reason.
    ///
    public func parse(_ string: String) throws -> Direction {
        let cleanString = try string.stripWhitespace()
        if let direction = Direction(rawValue: cleanString) {
            return direction
        } else {
            throw RuntimeError("Unsupported Direction string: \(string)")
        }
    }

    /// Checks whether the given string is a direction definition, after stripping all whitespace.
    internal func isDirection(_ string: String) -> Bool {
        do {
            let cleanString = try string.stripWhitespace()
            return try cleanString.wholeMatch(pattern: DirectionParser.DirectionPattern)
        } catch {
            return false
        }
    }
    
}
