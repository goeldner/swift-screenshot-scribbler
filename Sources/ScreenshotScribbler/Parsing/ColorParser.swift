//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

///
/// Parser for color syntax strings.
///
public class ColorParser {
 
    /// Matches a single color with optional alpha channel, e.g. "#0099FF" or "#0099FF80".
    internal static let HexColorPattern = "\\#([A-Fa-f0-9]{2})([A-Fa-f0-9]{2})([A-Fa-f0-9]{2})([A-Fa-f0-9]{2})?"
    
    /// Public initializer.
    public init() {}
    
    /// Encodes the given `Color` to a string in hex-format, e.g. "#FFFFFF" or "#FFFFFF80" if custom alpha opacity is defined.
    ///
    /// - Parameter color: The `Color` to encode.
    /// - Returns: The encoded string.
    ///
    public func encode(_ color: Color) -> String {
        return encode(red: color.red, green: color.green, blue: color.blue, alpha: color.alpha)
    }
    
    /// Encodes the given `CGColor` to a string in hex-format, e.g. "#FFFFFF" or "#FFFFFF80" if custom alpha opacity is defined.
    ///
    /// - Parameter color: The `CGColor` to encode.
    /// - Returns: The encoded string.
    ///
    public func encode(_ color: CGColor) -> String {
        return encode(Color(color))
    }
    
    /// Encodes the given color components to a string in hex-format, e.g. "#FFFFFF" or "#FFFFFF80" if custom alpha opacity is defined.
    ///
    /// - Parameters:
    ///   - red: Red color component (0 - 255)
    ///   - green: Green color component (0 - 255)
    ///   - blue: Blue color component (0 - 255)
    ///   - alpha: Alpha channel (0 - 255; default: 255)
    /// - Returns: The encoded string.
    ///
    internal func encode(red: Int, green: Int, blue: Int, alpha: Int = 255) -> String {
        if alpha != 255 {
            // include alpha channel only if not default
            return String(format: "#%02X%02X%02X%02X", red, green, blue, alpha)
        } else {
            // default is RGB only
            return String(format: "#%02X%02X%02X", red, green, blue)
        }
    }
    
    /// Parses the given string to a `Color` if supported. Throws a `RuntimeError` otherwise.
    ///
    /// - Parameter string: The string to parse.
    /// - Returns: The parsed `Color` instance.
    /// - Throws: `RuntimeError` if string cannot be parsed successfully for any reason.
    ///
    public func parse(_ string: String) throws -> Color {
        if isHexColor(string) {
            return try parseHexColor(string)
        } else {
            throw RuntimeError("Unsupported Color string: \(string)")
        }
    }
    
    /// Checks whether the given string is a single color definition, after stripping all whitespace.
    internal func isHexColor(_ string: String) -> Bool {
        do {
            let cleanString = try string.stripWhitespace()
            return try cleanString.wholeMatch(pattern: ColorParser.HexColorPattern)
        } catch {
            return false
        }
    }
    
    /// Parses the given color string, after stripping all whitespace.
    ///
    /// - Parameter string: The string to parse.
    /// - Returns: A `Color`.
    /// - Throws: `RuntimeError` if string cannot be parsed successfully for any reason.
    ///
    internal func parseHexColor(_ string: String) throws -> Color {
        let cleanString = try string.stripWhitespace()
        let rgba = try extractRGBA(cleanString)
        return Color(red: rgba.r, green: rgba.g, blue: rgba.b, alpha: rgba.a)
    }
    
    /// Extracts the red, green and blue color value and the alpha channel from the given string, each in range 0 to 255.
    ///
    /// Whitespace is not supported.
    ///
    /// The expected format is: `#AABBCC` or `#AABBCCDD`
    ///
    /// - Parameter string: The input string.
    /// - Returns: The tuple of red, green, blue and alpha.
    ///
    private func extractRGBA(_ string: String) throws -> (r: Int, g: Int, b: Int, a: Int) {
        let regex = try NSRegularExpression(pattern: ColorParser.HexColorPattern)
        let match = regex.firstMatch(in: string, options: [], range: string.nsRange())
        guard let match else {
            throw RuntimeError("Unsupported hex color string syntax. Format: #xxxxxx or #xxxxxxxx")
        }
        let nsString = string as NSString
        let hexR = nsString.substring(with: match.range(at: 1))
        let hexG = nsString.substring(with: match.range(at: 2))
        let hexB = nsString.substring(with: match.range(at: 3))
        let hexA = match.range(at: 4).length > 0 ? nsString.substring(with: match.range(at: 4)) : "FF"
        let r = Int(hexR, radix: 16)!
        let g = Int(hexG, radix: 16)!
        let b = Int(hexB, radix: 16)!
        let a = Int(hexA, radix: 16)!
        return (r, g, b, a)
    }

}
