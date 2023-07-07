//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

///
/// Support rotation of the graphics context for a given rectangle by a given angle.
/// Execute any drawing logic on the rotated context inside the adjusted rectangle.
///
public class RotationSupport {

    /// The rotation angle.
    private let angle: Angle

    /// Initializes the rotation.
    ///
    /// - Parameters:
    ///   - angle: The rotation angle.
    ///
    public init(angle: Angle) {
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
        if angle == Angle.zero {
            draw(rect, context)
            return
        }

        context.saveGState()

        // Set center as context action point, so rotation applies around that point
        let center = CGPoint(x: rect.midX, y: rect.midY)
        context.translateBy(x: center.x, y: center.y)

        // Rotate the context, using radians in the opposite direction as declared. The angle is defined throughout the code
        // base in natural direction, so positive values rotate clockwise and negative values rotate counter clockwise.
        // CoreGraphics does it the other way round, so we negate it here.
        let radians = angle.radians * -1
        context.rotate(by: radians)

        // Translate rect's lower left corner, because of the context action point that was shifted to the center
        let shiftedRect = CGRect(origin: CGPoint(x: -rect.size.width / 2, y: -rect.size.height / 2), size: rect.size)

        // Execute the draw logic
        draw(shiftedRect, context)

        context.restoreGState()
    }
}
