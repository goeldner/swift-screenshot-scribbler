//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

/// Types of one or more colors that may be drawn in different ways.
public enum ColorType: Equatable {
    
    /// One solid color.
    case solid(color: CGColor)
    
    /// A linear gradient defined by multiple colors and a direction.
    case linearGradient(colors: [CGColor], direction: Direction)
    
    /// A radial gradient defined by multiple colors and a direction.
    case radialGradient(colors: [CGColor], direction: Direction)
    
}

/// Implements conformity to the `CustomStringConvertible` protocol.
extension ColorType: CustomStringConvertible {
    
    /// Returns a description by using the type name and `ColorTypeParser.encode` representation.
    public var description: String {
        let parser = ColorTypeParser()
        return "\(ColorType.self)(\"\(parser.encode(self))\")"
    }
}

/// Implements conformity to the `Codable` protocol.
extension ColorType: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        let parser = ColorTypeParser()
        self = try parser.parse(value)
    }
    
    public func encode(to encoder: Encoder) throws {
        let parser = ColorTypeParser()
        let value = parser.encode(self)
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
    
}
