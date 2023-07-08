//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation

public extension String {
 
    /// Strips all whitespace from this string – at the begin, at the end, and everywhere in between
    /// by using the `NSRegularExpression` pattern `[[:whitespace:]]`.
    ///
    /// - Returns: The cleaned string.
    ///
    func stripWhitespace() throws -> String {
        let string = self
        let regex = try NSRegularExpression(pattern: "[[:whitespace:]]")
        return regex.stringByReplacingMatches(in: string, range: string.nsRange(), withTemplate: "")
    }

    /// Strips all non-numeric characters from this string – at the begin, at the end, and everywhere in between
    /// by using the `NSRegularExpression` pattern `[^\d\.\-]`. This keeps only digits and dots.
    ///
    /// - Returns: The cleaned string.
    ///
    func stripNonNumeric() throws -> String {
        let string = self
        let regex = try NSRegularExpression(pattern: "[^\\d\\.\\-]")
        return regex.stringByReplacingMatches(in: string, range: string.nsRange(), withTemplate: "")
    }

    /// Checks whether this string matches the given pattern completely.
    ///
    /// - Parameter pattern: The regular expression pattern.
    /// - Returns: `true` if it matches completely, otherwise `false`.
    ///
    func wholeMatch(pattern: String) throws -> Bool {
        let string = self
        let range = string.nsRange()
        let wholeMatchPattern = "^\(pattern)$"
        let regex = try NSRegularExpression(pattern: wholeMatchPattern)
        let matches = regex.matches(in: string, range: range)
        return matches.count > 0
    }

    /// Creates a `NSRange` covering this whole string.
    ///
    /// - Returns: The range.
    ///
    func nsRange() -> NSRange {
        let string = self
        return NSRange(location: 0, length: string.count)
    }

}
