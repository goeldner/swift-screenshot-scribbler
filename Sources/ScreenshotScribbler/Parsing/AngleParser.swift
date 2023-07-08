//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation

///
/// Parser for angles in radians or degrees.
///
public class AngleParser {

    /// Internal formatter which is configured for decimal numbers up to 4 fraction digits.
    private static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 4
        formatter.roundingMode = .halfUp
        formatter.locale = Locale(identifier: "en-us")
        return formatter
    }()

    /// Public initializer.
    public init() {}

    /// Encodes the given `Angle` to a string that can be parsed again by the `parse` method.
    ///
    /// - Parameter angle: The `Angle` to encode.
    /// - Returns: The encoded string.
    ///
    public func encode(_ angle: Angle) -> String {
        if angle == .zero {
            return "0"
        } else if angle.prefersDegrees {
            let value = AngleParser.decimalFormatter.string(from: angle.degrees as NSNumber)!
            return "\(value)deg"
        } else {
            let value = AngleParser.decimalFormatter.string(from: angle.radians as NSNumber)!
            return "\(value)rad"
        }
    }

    /// Parses the given string to an `Angle` if supported. Throws a `RuntimeError` otherwise.
    ///
    /// - Parameter string: The string to parse.
    /// - Returns: The parsed `Angle` instance.
    /// - Throws: `RuntimeError` if string cannot be parsed successfully for any reason.
    ///
    public func parse(_ string: String) throws -> Angle {
        let numberString = try string.stripNonNumeric()
        guard let value = Double(numberString) else {
            throw RuntimeError("Invalid number \"\(numberString)\" in Angle string: \(string)")
        }
        if value == 0 {
            return .zero
        } else if string.hasSuffix("deg") {
            return Angle(degrees: value)
        } else if string.hasSuffix("rad") {
            return Angle(radians: value)
        } else {
            throw RuntimeError("Unsupported Angle string: \(string)")
        }
    }

}
