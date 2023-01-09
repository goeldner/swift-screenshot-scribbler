//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

///
/// Parser for alignment syntax strings.
///
public class AlignmentParser {
 
    /// Public initializer.
    public init() {
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
        let remainingStringContent = try stripWhitespace(candidateString)
        if remainingStringContent.count > 0 {
            throw RuntimeError("Following alignment content could not be parsed: \(remainingStringContent)")
        }
        
        return Alignment(horizontal: horizontal, vertical: vertical)
    }
    
    /// Strips all whitespace from the given string – at the begin, at the end, and everywhere in between.
    ///
    /// - Parameter string: The input string.
    /// - Returns: The cleaned string.
    ///
    private func stripWhitespace(_ string: String) throws -> String {
        let regex = try NSRegularExpression(pattern: "[[:whitespace:]]")
        return regex.stringByReplacingMatches(in: string, range: range(string), withTemplate: "")
    }
    
    /// Creates a `NSRange` covering the whole given string.
    ///
    /// - Parameter string: The input string.
    /// - Returns: The range.
    ///
    private func range(_ string: String) -> NSRange {
        return NSRange(location: 0, length: string.count)
    }

}
