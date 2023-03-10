//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation

///
/// Parser for image scaling strings.
///
public class ImageScalingParser {
 
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
    
    /// Encodes the given `ImageScaling` to a string that can be parsed again by the `parse` method.
    ///
    /// - Parameter imageScaling: The `ImageScaling` to encode.
    /// - Returns: The encoded string.
    ///
    public func encode(_ imageScaling: ImageScaling) -> String {
        switch imageScaling {
        case .factor(let factor):
            return ImageScalingParser.decimalFormatter.string(from: factor as NSNumber)!
        case .mode(let mode):
            return mode.rawValue
        }
    }
    
    /// Parses the given string to a `ImageScaling` if supported. Throws a `RuntimeError` otherwise.
    ///
    /// - Parameter string: The string to parse.
    /// - Returns: The parsed `ImageScaling` instance.
    /// - Throws: `RuntimeError` if string cannot be parsed successfully for any reason.
    ///
    public func parse(_ string: String) throws -> ImageScaling {
        if let factor = Double(string) {
            return .factor(factor)
        } else if let mode = ImageScalingMode(rawValue: string) {
            return .mode(mode)
        } else {
            throw RuntimeError("Unsupported ImageScaling string: \(string)")
        }
    }

}
