//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation

///
/// Parser for direction strings.
///
public class DirectionParser {
 
    /// Matches a direction, e.g. "to-right", "to-top", "to-top-right" or "to-bottom-left"
    private static let DirectionPattern = "to\\-(top|right|bottom|left|top\\-right|top\\-left|bottom\\-right|bottom\\-left)"
    
    /// Public initializer.
    public init() {
    }
    
    /// Checks whether the given string is a direction definition, after stripping all whitespace.
    public func isDirection(_ string: String) -> Bool {
        do {
            let cleanString = try string.stripWhitespace()
            return try cleanString.wholeMatch(pattern: DirectionParser.DirectionPattern)
        } catch {
            return false
        }
    }
    
    /// Parses the given direction string.
    ///
    /// - Parameter string: The string to parse.
    /// - Returns: A `Direction` instance.
    /// - Throws: `RuntimeError` if string cannot be parsed successfully for any reason.
    ///
    public func parse(_ string: String) throws -> Direction {
        
        let candidateString = try string.stripWhitespace()
        
        // find a matching direction
        var direction: Direction? = nil
        for candidate in Direction.allCases {
            if candidateString == candidate.rawValue {
                direction = candidate
                break
            }
        }
        
        // ensure that a value was found
        guard let direction else {
            throw RuntimeError("Could not parse direction from: \(string)")
        }
        
        return direction
    }

}
