//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

///
/// Image rendering definition and drawing logic.
///
public class ImageRendering {

    /// The image to draw.
    private let image: CGImage
    
    /// The image scaling option.
    private let scaling: ImageScaling
    
    /// Horizontal alignment of the image, if it is not stretched to fill.
    private let horizontalAlignment: HorizontalAlignment
    
    /// Vertical alignment of the image, if it is not stretched to fill.
    private let verticalAlignment: VerticalAlignment

    /// Corner radius.
    private let cornerRadius: CGFloat?
    
    /// Rotation support.
    private let rotation: RotationSupport

    /// Initializes the rendering definition.
    ///
    /// - Parameters:
    ///   - image: The image to draw.
    ///   - scaling: The image scaling option. (Default: stretchFill)
    ///   - horizontalAlignment: Horizontal alignment of the image, if it is not stretched to fill. (Default: center)
    ///   - verticalAlignment: Vertical alignment of the image, if it is not stretched to fill. (Default: middle)
    ///   - cornerRadius: Corner radius that shall be applied to the image by clipping its corners. (Default: none)
    ///   - rotation: Rotation angle of the image. (Default: none)
    ///
    public init(image: CGImage, scaling: ImageScaling = .mode(.stretchFill), horizontalAlignment: HorizontalAlignment = .center, verticalAlignment: VerticalAlignment = .middle, cornerRadius: CGFloat? = nil, rotation: Angle = Angle.zero) {
        self.image = image
        self.scaling = scaling
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.cornerRadius = cornerRadius
        self.rotation = RotationSupport(angle: rotation)
    }

    /// Draws the image scaled and aligned to the given rectangle.
    ///
    /// Note: This method does not clip to the given rectangle, so the image may exceed the given area. Clipping to the desired area must be done by the caller.
    ///
    /// - Parameters:
    ///   - rect: The rectangle where the image is drawn.
    ///   - context: The graphics context.
    ///
    public func draw(in rect: CGRect, context: CGContext) {
        
        // determine factor that is needed to resize the image to fill or fit into the area
        let resizeFactorHorizontal = rect.width / CGFloat(image.width)
        let resizeFactorVertical = rect.height / CGFloat(image.height)
        let resizeFactor: CGFloat?
        switch scaling {
        case .mode(let mode):
            switch mode {
            case .none:
                // resize the image rect to the original image dimensions
                resizeFactor = 1
            case .stretchFill:
                // context.draw(image) stretch-fills the image into the rect by default automatically,
                // so there is nothing to resize manually here
                resizeFactor = nil
            case .aspectFill:
                // take the larger factor, to ensure the whole space is filled
                resizeFactor = max(resizeFactorHorizontal, resizeFactorVertical)
            case .aspectFit:
                // take the smaller factor, to ensure the image does not exceed the space
                resizeFactor = min(resizeFactorHorizontal, resizeFactorVertical)
            }
        case .factor(let factor):
            resizeFactor = factor
        }
        
        // optionally scale and align the image based on that factor
        let imageRect: CGRect
        if let resizeFactor {
            
            // resize
            let scaledImageWidth = CGFloat(image.width) * resizeFactor
            let scaledImageHeight = CGFloat(image.height) * resizeFactor
            let scaledImageSize = CGSize(width: scaledImageWidth, height: scaledImageHeight)
            
            // align
            let alignedPosX: CGFloat
            switch horizontalAlignment {
            case .left:
                alignedPosX = rect.minX
            case .center:
                alignedPosX = rect.midX - (scaledImageWidth / 2)
            case .right:
                alignedPosX = rect.maxX - scaledImageWidth
            }
            let alignedPosY: CGFloat
            switch verticalAlignment {
            case .top:
                alignedPosY = rect.maxY - scaledImageHeight
            case .middle:
                alignedPosY = rect.midY - (scaledImageHeight / 2)
            case .bottom:
                alignedPosY = rect.minY
            }
            let alignedOrigin = CGPoint(x: alignedPosX, y: alignedPosY)
            
            // adjusted rectangle
            imageRect = CGRect(origin: alignedOrigin, size: scaledImageSize)
            
        } else {
            // nothing to change
            imageRect = rect
        }

        // draw into the calculated area, optionally rotated and clipped to the corner radius
        rotation.rotate(rect: imageRect, context: context) { rotatedRect, context in
            context.saveGState()
            context.beginPath()
            context.addPath(path(of: rotatedRect))
            context.closePath()
            context.clip()
            context.draw(image, in: rotatedRect)
            context.restoreGState()
        }
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
