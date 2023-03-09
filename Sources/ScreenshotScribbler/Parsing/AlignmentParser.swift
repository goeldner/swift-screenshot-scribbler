//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation

///
/// Parser for alignment syntax strings.
///
public class AlignmentParser {
 
    /// Public initializer.
    public init() {}
    
    /// Encodes the given `Alignment` to a string that can be parsed again by the `parse` method.
    ///
    /// - Parameter alignment: The `Alignment` to encode.
    /// - Returns: The encoded string.
    ///
    public func encode(_ alignment: Alignment) -> String {
        return "\(alignment.vertical.rawValue) \(alignment.horizontal.rawValue)"
    }
    
    /// Parses the given alignment definition string.
    ///
    /// - Parameter string: The string to parse.
    /// - Returns: An `Alignment` instance.
    /// - Throws: `RuntimeError` if string cannot be parsed successfully for any reason.
    ///
    public func parse(_ string: String) throws -> Alignment {
        
        var candidateString = string
        
        // find a matching horizontal option and remove the possible match from string
        var horizontal: HorizontalAlignment = .center
        for candidate in HorizontalAlignment.allCases {
            if candidateString.contains(candidate.rawValue) {
                horizontal = candidate
                candidateString = candidateString.replacingOccurrences(of: candidate.rawValue, with: "")
                break
            }
        }
        
        // find a matching vertical option and remove the possible match from string
        var vertical: VerticalAlignment = .middle
        for candidate in VerticalAlignment.allCases {
            if candidateString.contains(candidate.rawValue) {
                vertical = candidate
                candidateString = candidateString.replacingOccurrences(of: candidate.rawValue, with: "")
                break
            }
        }
        
        // check if unparsed characters remain
        let remainingStringContent = try candidateString.stripWhitespace()
        if remainingStringContent.count > 0 {
            throw RuntimeError("Following alignment content could not be parsed: \(remainingStringContent)")
        }
        
        return Alignment(horizontal: horizontal, vertical: vertical)
    }
    
}
