//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation

/// An abstraction of an angle in degrees or radians.
///
/// The angle is defined in natural direction: positive values would rotate clockwise and negative values would rotate counter clockwise.
///
public struct Angle : Equatable {

    /// Alias of "π".
    public static let (pi, π) = (Double.pi, Double.pi)

    /// Angle with zero radians or degrees.
    public static let zero = Angle(radians: 0)

    /// The angle in radians.
    ///
    /// - Note: It is always stored in radians, even if it is initialized by the `init(degrees)` initializer.
    ///
    public private(set) var radians: Double

    /// The angle in degrees.
    ///
    /// - Note: This is always calculated based on the stored value in radians.
    ///
    public var degrees: Double { radians * 180.0 / Angle.pi }

    /// Flag that is `true` if the angle was initialized using the `init(degrees)` initializer.
    ///
    /// - Note: This may be used for de-/serializing without changing the user provided value.
    ///
    public let prefersDegrees: Bool

    /// Initializer with radians.
    ///
    ///  - Parameter radians: The angle in radians.
    ///
    public init(radians: Double) {
        self.radians = radians
        self.prefersDegrees = false
    }

    /// Initializer with degrees.
    ///
    ///  - Parameter degrees: The angle in degrees.
    ///
    public init(degrees: Double) {
        self.radians = degrees * Angle.pi / 180.0
        self.prefersDegrees = true
    }

    // `Equatable`
    public static func ==(lhs: Angle, rhs: Angle) -> Bool {
        return lhs.radians == rhs.radians
    }
}

/// Implements conformity to the `CustomStringConvertible` protocol.
extension Angle: CustomStringConvertible {

    /// Returns a description by using the type name and `AngleParser.encode` representation.
    public var description: String {
        let parser = AngleParser()
        return "\(Angle.self)(\(parser.encode(self)))"
    }
}

/// Implements conformity to the `Codable` protocol.
extension Angle: Codable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        let parser = AngleParser()
        self = try parser.parse(value)
    }

    public func encode(to encoder: Encoder) throws {
        let parser = AngleParser()
        let value = parser.encode(self)
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
