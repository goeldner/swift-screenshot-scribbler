//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation

/// Image scaling options.
public enum ImageScaling: Equatable {
    
    /// Scale the image according to one of the pre-defined modes.
    case mode(_ mode: ImageScalingMode)
    
    /// Scale the image according to a custom factor.
    case factor(_ factor: Double)
    
}

/// Implements conformity to the `CustomStringConvertible` protocol.
extension ImageScaling: CustomStringConvertible {
    
    /// Returns a description by using the type name and `ImageScalingParser.encode` representation.
    public var description: String {
        let parser = ImageScalingParser()
        return "\(ImageScaling.self)(\"\(parser.encode(self))\")"
    }
}

/// Implements conformity to the `Codable` protocol.
extension ImageScaling: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        let parser = ImageScalingParser()
        self = try parser.parse(value)
    }
    
    public func encode(to encoder: Encoder) throws {
        let parser = ImageScalingParser()
        let value = parser.encode(self)
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
    
}
