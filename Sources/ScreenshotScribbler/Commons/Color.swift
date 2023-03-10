//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation

///
/// Abstraction of an RGBA color independent from CoreGraphics, which enables implementing additional protocols like `Codable`.
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
