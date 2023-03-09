//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

///
/// Parser for gradient and color syntax strings.
///
public class ColorTypeParser {
 
    /// Matches a list of two or more colors, e.g. "#112233,#AABBCC"
    private static let HexColorListPattern = "(\(ColorParser.HexColorPattern)[,])+\(ColorParser.HexColorPattern)"
    
    /// Matches a gradient type, e.g. "linear-gradient" or "radial-gradient"
    private static let GradientTypePattern = "linear\\-gradient|radial\\-gradient"
    
    /// Matches a gradient definition with a list of two or more colors and an optional direction as first argument.
    ///
    /// Examples:
    /// - "linear-gradient(#112233,#AABBCC,#aabbcc)"
    /// - "linear-gradient(to-bottom-right,#112233,#AABBCC)"
    /// - "radial-gradient(#112233,#AABBCC)"
    ///
    private static let GradientPattern = "(\(GradientTypePattern))\\(((\(DirectionParser.DirectionPattern)[,])?\(HexColorListPattern))\\)"
    
    /// Public initializer.
    public init() {}
    
    /// Encodes the given `ColorType` to a string that can be parsed again by the `parse` method.
    ///
    /// - Parameter colorType: The `ColorType` to encode.
    /// - Returns: The encoded string.
    ///
    public func encode(_ colorType: ColorType) -> String {
        switch colorType {
        case .solid(let color):
            let colorParser = ColorParser()
            return colorParser.encode(color)
        case .linearGradient(let colors, let direction):
            return "linear-gradient(\(direction.rawValue), \(encode(colors)))"
        case .radialGradient(let colors, let direction):
            return "radial-gradient(\(direction.rawValue), \(encode(colors)))"
        }
    }
    
    /// Encodes the given array of `Color` instances to a string list in hex-format, e.g. "#000000, #FFFFFF".
    ///
    /// - Parameter colors: The `CGColor`array to encode.
    /// - Returns: The encoded string.
    ///
    internal func encode(_ colors: [Color]) -> String {
        let colorParser = ColorParser()
        let colorStrings = colors.map{ color in colorParser.encode(color) }
        return colorStrings.joined(separator: ", ")
    }
    
    /// Encodes the given array of `CGColor` instances to a string list in hex-format, e.g. "#000000, #FFFFFF".
    ///
    /// - Parameter colors: The `CGColor`array to encode.
    /// - Returns: The encoded string.
    ///
    internal func encode(_ colors: [CGColor]) -> String {
        let colorParser = ColorParser()
        let colorStrings = colors.map{ color in colorParser.encode(color) }
        return colorStrings.joined(separator: ", ")
    }
    
    /// Parses the given string to a `ColorType` if supported. Throws a `RuntimeError` otherwise.
    ///
    /// - Parameter string: The string to parse.
    /// - Returns: The parsed `ColorType` instance.
    /// - Throws: `RuntimeError` if string cannot be parsed successfully for any reason.
    ///
    public func parse(_ string: String) throws -> ColorType {
        let colorParser = ColorParser()
        if colorParser.isHexColor(string) {
            return .solid(color: try colorParser.parse(string).CGColor)
        } else if self.isGradient(string) {
            return try self.parseGradient(string)
        } else {
            throw RuntimeError("Unsupported ColorType string: \(string)")
        }
    }
    
    /// Checks whether the given string is a gradient definition, after stripping all whitespace.
    internal func isGradient(_ string: String) -> Bool {
        do {
            let cleanString = try string.stripWhitespace()
            return try cleanString.wholeMatch(pattern: ColorTypeParser.GradientPattern)
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
    internal func parseGradient(_ string: String) throws -> ColorType {
        let cleanString = try string.stripWhitespace()
        var (name, args) = try extractGradientNameAndArguments(cleanString)
        
        // First argument could be a direction
        var direction: Direction? = nil
        let directionParser = DirectionParser()
        if directionParser.isDirection(args[0]) {
            direction = try directionParser.parse(args[0])
            args.removeFirst()
        }
        
        // All other arguments should be colors
        let colorParser = ColorParser()
        let colors = try args.map { string in try colorParser.parse(string).CGColor }
        
        return try createGradientColorType(name: name, colors: colors, direction: direction)
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
        let regex = try NSRegularExpression(pattern: ColorTypeParser.GradientPattern)
        let match = regex.firstMatch(in: string, options: [], range: string.nsRange())
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
    /// based on the given gradient name, including the attached list of colors and an optional direction.
    ///
    /// If direction is not given, then `.toBottom` is used as default.
    ///
    /// - Parameters:
    ///   - name: The gradient name.
    ///   - colors: The list of colors.
    ///   - direction: The direction (optional).
    /// - Returns: The `ColorType` instance.
    ///
    private func createGradientColorType(name: String, colors: [CGColor], direction: Direction?) throws -> ColorType {
        switch name {
        case "linear-gradient":
            return .linearGradient(colors: colors, direction: direction ?? .toBottom)
        case "radial-gradient":
            return .radialGradient(colors: colors, direction: direction ?? .toBottom)
        default:
            throw RuntimeError("Unsupported gradient type: \(name)")
        }
    }
    
}
