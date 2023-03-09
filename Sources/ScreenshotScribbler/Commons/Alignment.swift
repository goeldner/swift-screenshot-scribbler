//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation

/// Contains settings for horizontal and vertical alignment.
public struct Alignment: Equatable {
    
    /// The horizontal alignment.
    public let horizontal: HorizontalAlignment
    
    /// The vertical alignment.
    public let vertical: VerticalAlignment
    
    /// Creates a new instance with horizontal and vertical alignment.
    ///
    /// - Parameters:
    ///   - horizontal: The horizontal alignment.
    ///   - vertical: The vertical alignment.
    ///
    public init(horizontal: HorizontalAlignment, vertical: VerticalAlignment) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
}

/// Implements conformity to the `CustomStringConvertible` protocol.
extension Alignment: CustomStringConvertible {
    
    /// Returns a description by using the type name and `AlignmentParser.encode` representation.
    public var description: String {
        let parser = AlignmentParser()
        return "\(Alignment.self)(\"\(parser.encode(self))\")"
    }
}

/// Implements conformity to the `Codable` protocol.
extension Alignment: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        let parser = AlignmentParser()
        self = try parser.parse(value)
    }
    
    public func encode(to encoder: Encoder) throws {
        let parser = AlignmentParser()
        let value = parser.encode(self)
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
    
}
