//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

///
/// Rectangle rendering definition, drawing and clipping logic.
///
public class RectangleRendering {

    /// Fill color of the rectangle.
    private let fillColor: CGColor?
    
    /// Corner radius.
    private let cornerRadius: CGFloat?
    
    /// Shadow size.
    private let shadowSize: CGFloat?
    
    /// Shadow color.
    private let shadowColor: CGColor?
    
    /// Initializes the rendering definition.
    ///
    /// - Parameters:
    ///   - fillColor: Optional fill color of the rectangle.
    ///   - cornerRadius: Optional corner radius.
    ///   - shadowSize: Optional shadow size.
    ///   - shadowColor: Optional shadow color.
    ///
    public init(fillColor: CGColor? = nil, cornerRadius: CGFloat? = nil, shadowSize: CGFloat? = nil, shadowColor: CGColor? = nil) {
        self.fillColor = fillColor
        self.cornerRadius = cornerRadius
        self.shadowSize = shadowSize
        self.shadowColor = shadowColor
    }

    /// Draws the rectangle including an optional shadow and optional rounded corners.
    ///
    /// - Parameters:
    ///   - rect: The rectangle to draw.
    ///   - context: The graphics context.
    ///
    public func draw(in rect: CGRect, context: CGContext) {
        context.saveGState()
        context.beginPath()
        context.addPath(path(of: rect))
        context.closePath()
        if let shadowColor, let shadowSize, shadowSize > 0 {
            context.setShadow(offset: CGSize(width: 0, height: 0), blur: shadowSize, color: shadowColor)
        }
        if let fillColor {
            context.setFillColor(fillColor)
            context.fillPath()
        }
        context.restoreGState()
    }
    
    /// Clips the graphics context to the rectangle, optionally also clipped to the defined rounded corners.
    ///
    /// - Parameters:
    ///   - rect: The rectangle to clip.
    ///   - context: The graphics context.
    ///
    public func clip(to rect: CGRect, context: CGContext) {
        context.beginPath()
        context.addPath(path(of: rect))
        context.closePath()
        context.clip()
    }
    
    /// Creates a path of the rectangle, also considering optionally defined rounded corners.
    ///
    /// - Parameter rect: The rectangle.
    /// - Returns: The path of the rectangle.
    ///
    private func path(of rect: CGRect) -> CGPath {
        if let cornerRadius, cornerRadius > 0 {
            return CGPath(roundedRect: rect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        } else {
            return CGPath(rect: rect, transform: nil)
        }
    }
}
