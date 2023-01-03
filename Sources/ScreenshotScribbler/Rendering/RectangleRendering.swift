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
    private let fillColor: ColorType?
    
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
    public init(fillColor: ColorType? = nil, cornerRadius: CGFloat? = nil, shadowSize: CGFloat? = nil, shadowColor: CGColor? = nil) {
        self.fillColor = fillColor
        self.cornerRadius = cornerRadius
        self.shadowSize = shadowSize
        self.shadowColor = shadowColor
    }

    /// Draws the rectangle with optional solid or gradient fill, optional shadow and optional rounded corners.
    ///
    /// - Parameters:
    ///   - rect: The rectangle to draw.
    ///   - context: The graphics context.
    ///
    public func draw(in rect: CGRect, context: CGContext) {
        
        // Draw shadow first behind the filled rect, which will be clipped and shadow outside not visible
        drawShadowRect(rect: rect, context: context)
        
        switch fillColor {
        case .solid(let color):
            drawSolidRect(rect: rect, color: color, context: context)
        case .linearGradient(let colors):
            drawLinearGradientRect(rect: rect, colors: colors, context: context)
        case .radialGradient(let colors):
            drawRadialGradientRect(rect: rect, colors: colors, context: context)
        case .none:
            break // no fill
        }
    }
    
    /// Draws the rectangle filled with the shadow color and surrounded by a shadow, if shadow size and color is defined.
    ///
    /// Considers also optionally defined rounded corners.
    ///
    /// - Parameters:
    ///   - rect: The rectangle to draw.
    ///   - context: The graphics context.
    ///   
    private func drawShadowRect(rect: CGRect, context: CGContext) {
        if let shadowColor, let shadowSize, shadowSize > 0 {
            context.saveGState()
            context.beginPath()
            context.addPath(path(of: rect))
            context.closePath()
            context.setShadow(offset: CGSize(width: 0, height: 0), blur: shadowSize, color: shadowColor)
            context.setFillColor(shadowColor)
            context.fillPath()
            context.restoreGState()
        }
    }
    
    /// Draws the rectangle filled with given color.
    ///
    /// Considers also optionally defined rounded corners. Ignores the shadow.
    ///
    /// - Parameters:
    ///   - rect: The rectangle to draw.
    ///   - color: The fill color.
    ///   - context: The graphics context.
    ///
    private func drawSolidRect(rect: CGRect, color: CGColor, context: CGContext) {
        context.saveGState()
        context.beginPath()
        context.addPath(path(of: rect))
        context.closePath()
        context.setFillColor(color)
        context.fillPath()
        context.restoreGState()
    }
    
    /// Draws the rectangle filled with a linear gradient of given colors,
    /// starting with the first color at the top edge and the last color at the bottom edge.
    ///
    /// Considers also optionally defined rounded corners. Ignores the shadow.
    ///
    /// - Parameters:
    ///   - rect: The rectangle to draw.
    ///   - colors: The colors defining the gradient.
    ///   - context: The graphics context.
    ///
    private func drawLinearGradientRect(rect: CGRect, colors: [CGColor], context: CGContext) {
        
        let colorSpace = context.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!
        let colorLocations = try! distributeColorLocationsEqually(numColors: colors.count)
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)!
        let startPoint = CGPoint(x: rect.midX, y: rect.maxY)
        let endPoint = CGPoint(x: rect.midX, y: rect.minY)
        
        context.saveGState()
        context.beginPath()
        context.addPath(path(of: rect))
        context.closePath()
        context.clip()
        context.drawLinearGradient(
            gradient,
            start: startPoint,
            end: endPoint,
            options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
        )
        context.restoreGState()
    }
    
    /// Draws the rectangle filled with a radial gradient of given colors,
    /// starting with the first color at the top edge and the last color at the bottom edge
    /// and using a radius of half the width of the rectangle.
    ///
    /// Considers also optionally defined rounded corners. Ignores the shadow.
    ///
    /// - Parameters:
    ///   - rect: The rectangle to draw.
    ///   - colors: The colors defining the gradient.
    ///   - context: The graphics context.
    ///
    private func drawRadialGradientRect(rect: CGRect, colors: [CGColor], context: CGContext) {
        
        let colorSpace = context.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!
        let colorLocations = try! distributeColorLocationsEqually(numColors: colors.count)
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)!
        let startPoint = CGPoint(x: rect.midX, y: rect.maxY)
        let endPoint = CGPoint(x: rect.midX, y: rect.minY)
        let radius = rect.width / 2
        
        context.saveGState()
        context.beginPath()
        context.addPath(path(of: rect))
        context.closePath()
        context.clip()
        context.drawRadialGradient(
            gradient,
            startCenter: startPoint,
            startRadius: radius,
            endCenter: endPoint,
            endRadius: radius,
            options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
        )
        context.restoreGState()
    }
    
    /// Creates an array starting with 0.0 and ending with 1.0 and filling the steps equally
    /// for the given number of colors.
    ///
    /// Example:
    /// - `numColors = 5`
    /// - => `[0.0, 0.25, 0.5, 0.75, 1.0]`
    ///
    /// - Parameter numColors: Number of colors to distribute.
    /// - Returns: Array of equally distributed steps.
    /// - Throws: `RuntimeError` if less than 2 colors are provided.
    /// 
    private func distributeColorLocationsEqually(numColors: Int) throws -> [CGFloat] {
        guard numColors > 1 else {
            throw RuntimeError("Not enough colors to distribute them equally inside a gradient: \(numColors)")
        }
        let stepSize = 1.0 / CGFloat(numColors - 1)
        var steps = Array(stride(from: CGFloat(0.0), through: CGFloat(1.0), by: stepSize))
        // Always correct last value to exactly 1.0, because maybe floating point errors have added up
        if steps.count == numColors {
            steps[steps.count - 1] = 1.0
        }
        // Ensure that last value is available, which is not guaranteed by stride
        if steps.count < numColors {
            steps.append(1.0)
        }
        return steps
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
