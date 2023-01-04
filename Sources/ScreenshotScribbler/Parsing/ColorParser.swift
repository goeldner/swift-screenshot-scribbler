//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

///
/// Parser for gradient and color syntax strings.
///
public class ColorParser {
 
    /// Matches a single color, e.g. "#0099FF"
    private static let HexColorPattern = "\\#([A-Fa-f0-9]{2})([A-Fa-f0-9]{2})([A-Fa-f0-9]{2})"
    
    /// Matches a list of two or more colors, e.g. "#112233,#AABBCC"
    private static let HexColorListPattern = "(\(HexColorPattern)[,])+\(HexColorPattern)"
    
    /// Matches a gradient definition with a list of two or more colors, e.g.
    /// "linear-gradient(#112233,#AABBCC,#aabbcc)" or "radial-gradient(#112233,#AABBCC)"
    private static let GradientPattern = "(linear\\-gradient|radial\\-gradient)\\((\(HexColorListPattern))\\)"
    
    /// Public initializer.
    public init() {
    }
    
    /// Checks whether the given string is a gradient definition, after stripping all whitespace.
    public func isGradient(_ string: String) -> Bool {
        do {
            let cleanString = try stripWhitespace(string)
            return try wholeMatch(cleanString, pattern: ColorParser.GradientPattern)
        } catch {
            return false
        }
    }
    
    /// Checks whether the given string is a single color definition, after stripping all whitespace.
    public func isHexColor(_ string: String) -> Bool {
        do {
            let cleanString = try stripWhitespace(string)
            return try wholeMatch(cleanString, pattern: ColorParser.HexColorPattern)
        } catch {
            return false
        }
    }
    
    /// Parses the given gradient definition string, after stripping all whitespace.
    ///
    /// - Parameter string: The string to parse.
    /// - Returns: `ColorType.linearGradient` or `ColorType.radialGradient`.
    /// - Throws: `RuntimeError` if string cannot be parsed successfully for any reason.
    ///
    public func parseGradient(_ string: String) throws -> ColorType {
        let cleanString = try stripWhitespace(string)
        let (name, args) = try extractGradientNameAndArguments(cleanString)
        let colors = try args.map { string in try parseHexColor(string) }
        return try createGradientColorType(name: name, colors: colors)
    }
    
    /// Parses the given single color definition string, after stripping all whitespace.
    ///
    /// - Parameter string: The string to parse.
    /// - Returns: A `CGColor`.
    /// - Throws: `RuntimeError` if string cannot be parsed successfully for any reason.
    ///
    public func parseHexColor(_ string: String) throws -> CGColor {
        let cleanString = try stripWhitespace(string)
        let rgb = try extractRGB(cleanString)
        let r = CGFloat(rgb.r) / 255
        let g = CGFloat(rgb.g) / 255
        let b = CGFloat(rgb.b) / 255
        return CGColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    /// Extracts the gradient name (the string part before the brackets) and the list of gradient arguments
    /// (the string part inside the brackets, splitted at each comma) from the given string.
    ///
    /// Whitespace is not supported.
    ///
    /// The expected format is: `<name>(arg1,arg2,...)`
    ///
    /// - Parameter string: The input string.
    /// - Returns: The tuple of name and arguments.
    ///
    private func extractGradientNameAndArguments(_ string: String) throws -> (name: String, args: [String]) {
        let regex = try NSRegularExpression(pattern: ColorParser.GradientPattern)
        let match = regex.firstMatch(in: string, options: [], range: range(string))
        guard let match else {
            throw RuntimeError("Unsupported gradient syntax. Format: <name>(arg1,arg2,...)")
        }
        let nsString = string as NSString
        let name = nsString.substring(with: match.range(at: 1))
        let rawArgs = nsString.substring(with: match.range(at: 2))
        let args = rawArgs.components(separatedBy: ",")
        return (name, args)
    }

    /// Creates an instance of `ColorType.linearGradient` or `ColorType.radialGradient`
    /// based on the given gradient name and including the attached list of colors.
    ///
    /// - Parameters:
    ///   - name: The gradient name.
    ///   - colors: The list of colors.
    /// - Returns: The `ColorType` instance.
    ///
    private func createGradientColorType(name: String, colors: [CGColor]) throws -> ColorType {
        switch name {
        case "linear-gradient":
            return .linearGradient(colors: colors)
        case "radial-gradient":
            return .radialGradient(colors: colors)
        default:
            throw RuntimeError("Unsupported gradient type: \(name)")
        }
    }
    
    /// Extracts the red, green and blue color value from the given string, each in range 0 to 255.
    ///
    /// Whitespace is not supported.
    ///
    /// The expected format is: `#AABBCC`
    ///
    /// - Parameter string: The input string.
    /// - Returns: The tuple of red, green and blue.
    ///
    private func extractRGB(_ string: String) throws -> (r: Int, g: Int, b: Int) {
        let regex = try NSRegularExpression(pattern: ColorParser.HexColorPattern)
        let match = regex.firstMatch(in: string, options: [], range: range(string))
        guard let match else {
            throw RuntimeError("Unsupported hex color string syntax. Format: #xxxxxx")
        }
        let nsString = string as NSString
        let hexR = nsString.substring(with: match.range(at: 1))
        let hexG = nsString.substring(with: match.range(at: 2))
        let hexB = nsString.substring(with: match.range(at: 3))
        let r = Int(hexR, radix: 16)!
        let g = Int(hexG, radix: 16)!
        let b = Int(hexB, radix: 16)!
        return (r, g, b)
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
    
    /// Checks the string whether it matches the given pattern completely.
    ///
    /// - Parameters:
    ///   - string: The string to check.
    ///   - pattern: The regular expression pattern.
    /// - Returns: `true` if it matches completely, otherwise `false`.
    ///
    private func wholeMatch(_ string: String, pattern: String) throws -> Bool {
        let range = NSRange(location: 0, length: string.count)
        let wholeMatchPattern = "^\(pattern)$"
        let regex = try NSRegularExpression(pattern: wholeMatchPattern)
        let matches = regex.matches(in: string, range: range)
        return matches.count > 0
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
