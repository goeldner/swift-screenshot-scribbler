//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation

/// An abstraction of an angle in degrees or radians.
///
/// The angle is defined in natural direction: positive values would rotate clockwise and negative values would rotate counter clockwise.
///
public struct Angle : CustomStringConvertible, Equatable {

    /// Alias of "π".
    public static let (pi, π) = (Double.pi, Double.pi)

    /// Angle with zero radians or degrees.
    public static let zero = Angle(radians: 0)

    /// The angle in radians.
    ///
    /// Note: It is always stored in radians, even if it is initialized by the `init(degrees)` initializer.
    ///
    public private(set) var radians: Double

    /// The angle in degrees.
    ///
    /// Note: This is always calculated based on the stored value in radians.
    ///
    public var degrees: Double { radians * 180.0 / Angle.pi }

    /// Flag that is `true` if the angle was initialized using the `init(degrees)` initializer.
    ///
    /// Note: This may be used for de-/serializing without changing the user provided value.
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

    // `CustomStringConvertible`
    public var description: String {
        return "\(degrees) degrees, \(radians) radians"
    }

    // `Equatable`
    public static func ==(lhs: Angle, rhs: Angle) -> Bool {
        return lhs.radians == rhs.radians
    }
}
