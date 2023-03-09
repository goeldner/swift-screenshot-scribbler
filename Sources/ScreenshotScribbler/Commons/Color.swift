//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

///
/// Abstraction of `CGColor` that enables implementing additional protocols like `Codable`.
///
public struct Color: Equatable {

    /// Red color component (0 - 255)
    public let red: Int
    
    /// Green color component (0 - 255)
    public let green: Int
    
    /// Blue color component (0 - 255)
    public let blue: Int
    
    /// Alpha channel (0 - 255; default: 255)
    public let alpha: Int
    
    /// Public initializer with all color components. Alpha channel is optional and 1.0 by default.
    ///
    /// - Parameters:
    ///   - red: Red color component (0 - 255)
    ///   - green: Green color component (0 - 255)
    ///   - blue: Blue color component (0 - 255)
    ///   - alpha: Alpha channel (0 - 255; default: 255)
    ///
    public init(red: Int, green: Int, blue: Int, alpha: Int = 255) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}

/// Extension providing convenience methods for working with `CGColor` instances.
extension Color {
    
    /// Convenience access to a `CGColor` instance.
    public var CGColor: CGColor {
        let r = CGFloat(red) / 255
        let g = CGFloat(green) / 255
        let b = CGFloat(blue) / 255
        let a = CGFloat(alpha) / 255
        return CoreGraphics.CGColor(red: r, green: g, blue: b, alpha: a)
    }
    
    /// Public initializer based on a `CGColor` instance.
    ///
    /// - Parameter color: The `CGColor` instance.
    ///
    public init(_ color: CoreGraphics.CGColor) {
        let r = Int(round(color.components![0] * 255))
        let g = Int(round(color.components![1] * 255))
        let b = Int(round(color.components![2] * 255))
        let a = color.numberOfComponents > 3 ? Int(round(color.components![3] * 255)) : 255
        self = Color(red: r, green: g, blue: b, alpha: a)
    }
}

/// Implements conformity to the `CustomStringConvertible` protocol.
extension Color: CustomStringConvertible {
    
    /// Returns a description by using the type name and `ColorParser.encode` representation.
    public var description: String {
        let parser = ColorParser()
        return "\(Color.self)(\"\(parser.encode(self))\")"
    }
}

/// Implements conformity to the `Codable` protocol.
extension Color: Codable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        let parser = ColorParser()
        self = try parser.parse(value)
    }

    public func encode(to encoder: Encoder) throws {
        let parser = ColorParser()
        let value = parser.encode(self)
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
