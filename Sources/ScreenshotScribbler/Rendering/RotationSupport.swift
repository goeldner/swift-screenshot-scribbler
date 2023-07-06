//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

///
/// Support rotation of the graphics context for a given rectangle by a given angle.
/// Execute any drawing logic on the rotated context inside the adjusted rectangle.
///
/// The angle is defined in radians. Positive values rotate to the left (counter clockwise) and negative numbers to the right (clockwise).
/// For example, pi/2 rotates 90° to the left; -pi rotates 180° to the right.
///
public class RotationSupport {

    /// Rotation angle in radians.
    private let angle: CGFloat

    /// Initializes the rotation.
    ///
    /// - Parameters:
    ///   - angle: The rotation angle in radians.
    ///
    public init(angle: CGFloat) {
        self.angle = angle
    }

    /// Executes the `draw` closure on the given context, after rotating the rectangle by the defined angle.
    ///
    /// Note: If angle is 0, then the rotation logic is skipped completely.
    ///
    /// - Parameters:
    ///   - rect: The rectangle to rotate.
    ///   - context: The graphics context.
    ///   - draw: The closure executing the drawing logic on the given context inside the rotated rectangle.
    ///
    public func rotate(rect: CGRect, context: CGContext, draw: (CGRect, CGContext) -> ()) {

        // Support direct unrotated drawing
        if angle == 0 {
            draw(rect, context)
            return
        }

        context.saveGState()

        // Set center as context action point, so rotation applies around that point
        let center = CGPoint(x: rect.midX, y: rect.midY)
        context.translateBy(x: center.x, y: center.y)

        // Rotate the context
        context.rotate(by: angle)

        // Translate rect's lower left corner, because of the context action point that was shifted to the center
        let shiftedRect = CGRect(origin: CGPoint(x: -rect.size.width / 2, y: -rect.size.height / 2), size: rect.size)

        // Execute the draw logic
        draw(shiftedRect, context)

        context.restoreGState()
    }
}
