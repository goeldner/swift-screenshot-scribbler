//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics
import UniformTypeIdentifiers

///
/// The main class of this library that coordinates the screenshot scribbling and
/// is invoked using the `generate` function as entry point.
/// 
public struct ScreenshotScribbler {

    private let screenshot: Data
    private let backgroundImage: Data?
    private let caption: String?
    private let layout: LayoutConfig

    /// Initializes the screenshot scribbler with a screenshot image and caption.
    ///
    /// - Parameters:
    ///   - screenshot: The screenshot in PNG or JPEG format.
    ///   - backgroundImage: The image to use a background. (optional).
    ///   - caption: The caption to display next to the screenshot (optional).
    ///   - layout: The layout configuration (optional).
    ///
    public init(screenshot: Data, backgroundImage: Data? = nil, caption: String? = nil, layout: LayoutConfig = LayoutConfig()) {
        self.screenshot = screenshot
        self.backgroundImage = backgroundImage
        self.caption = caption
        self.layout = layout
    }

    /// Generates the output image based on the configured screenshot image, caption and layout settings.
    ///
    /// - Returns: The output image as PNG data.
    ///
    public func generate() throws -> Data {
        
        // Read the input image and create a graphics context with same size
        let image = try self.screenshot.createCGImage()
        let context = try image.createCGContext()
        
        // Calculate total area and cover it with a background color
        let totalArea = CGRect(x: 0, y: 0, width: image.width, height: image.height)
        try drawBackground(in: totalArea, context: context)
        
        // Perform further layout specific drawing
        switch self.layout.layoutType {
        case .captionBeforeScreenshot:
            drawLayoutCaptionBeforeScreenshot(in: totalArea, screenshot: image, context: context)
        case .captionAfterScreenshot:
            drawLayoutCaptionAfterScreenshot(in: totalArea, screenshot: image, context: context)
        case .captionBetweenScreenshots:
            drawLayoutCaptionBetweenScreenshots(in: totalArea, screenshot: image, context: context)
        case .screenshotOnly:
            drawLayoutScreenshotOnly(in: totalArea, screenshot: image, context: context)
        }
        
        // Generate output PNG
        let outputImage = try context.createCGImage()
        let outputImageData = try outputImage.encode(encoding: .png)
        return outputImageData
    }
    
    /// Draws a background color covering the whole rect, and if a background image is defined,
    /// draws the image according to its scaling and alignment options.
    ///
    /// - Parameters:
    ///   - rect: The rectangle to cover with color and optional image.
    ///   - context: The graphics context.
    ///
    private func drawBackground(in rect: CGRect, context: CGContext) throws {
        
        // background color
        let colorRendering = RectangleRendering(fillColor: self.layout.backgroundColor)
        colorRendering.draw(in: rect, context: context)
        
        // optional background image
        if let backgroundImage {
            let image = try backgroundImage.createCGImage()
            let imageRendering = ImageRendering(image: image,
                                                scaling: self.layout.backgroundImageScaling,
                                                horizontalAlignment: self.layout.backgroundImageAlignment.horizontal,
                                                verticalAlignment: self.layout.backgroundImageAlignment.vertical)
            imageRendering.draw(in: rect, context: context)
        }
    }
    
    /// Draws the caption before the screenshot inside the given rectangle.
    ///
    /// - Parameters:
    ///   - rect: The rectangle to cover with caption and screenshot.
    ///   - screenshot: The screenshot to draw.
    ///   - context: The graphics context.
    ///
    private func drawLayoutCaptionBeforeScreenshot(in rect: CGRect, screenshot: CGImage, context: CGContext) {
        
        // Divide rect after height of text area
        let textAreaHeight = rect.height * self.layout.captionSizeFactor
        let (topArea, bottomArea) = rect.divided(atDistance: textAreaHeight, from: .maxYEdge)
        
        // Place the caption centered inside the text area, with margin
        if let caption {
            let textAreaMargin = (rect.width - (rect.width * self.layout.screenshotSizeFactor)) / 2
            let textArea = topArea.insetBy(dx: textAreaMargin, dy: 0)
            drawText(caption, in: textArea, context: context)
        }
        
        // Place the screenshot below the caption
        drawImage(screenshot, in: bottomArea, verticalAlignment: .top, context: context)
    }
    
    /// Draws the caption after the screenshot inside the given rectangle.
    ///
    /// - Parameters:
    ///   - rect: The rectangle to cover with caption and screenshot.
    ///   - screenshot: The screenshot to draw.
    ///   - context: The graphics context.
    ///
    private func drawLayoutCaptionAfterScreenshot(in rect: CGRect, screenshot: CGImage, context: CGContext) {
        
        // Divide rect after height of image area (total height without text area height)
        let textAreaHeight = rect.height * self.layout.captionSizeFactor
        let (topArea, bottomArea) = rect.divided(atDistance: rect.height - textAreaHeight, from: .maxYEdge)
        
        // Place the caption centered inside the text area, with margin
        if let caption {
            let textAreaMargin = (rect.width - (rect.width * self.layout.screenshotSizeFactor)) / 2
            let textArea = bottomArea.insetBy(dx: textAreaMargin, dy: 0)
            drawText(caption, in: textArea, context: context)
        }
        
        // Place the screenshot above the caption
        drawImage(screenshot, in: topArea, verticalAlignment: .bottom, context: context)
    }
    
    /// Draws the caption surrounded by two parts of the screenshot on top and bottom inside the given rectangle.
    ///
    /// - Parameters:
    ///   - rect: The rectangle to cover with caption and screenshot.
    ///   - screenshot: The screenshot to draw.
    ///   - context: The graphics context.
    ///
    private func drawLayoutCaptionBetweenScreenshots(in rect: CGRect, screenshot: CGImage, context: CGContext) {
        
        // First, divide rect after height of half image area
        let textAreaHeight = rect.height * self.layout.captionSizeFactor
        let halfImageAreaHeight = (rect.height - textAreaHeight) / 2
        let (topArea, remainingRect) = rect.divided(atDistance: halfImageAreaHeight, from: .maxYEdge)
        
        // Second, divide remaining rect after height of text area, so we get:
        // - topArea:    half image
        // - middleArea: text
        // - bottomArea: half image
        let (middleArea, bottomArea) = remainingRect.divided(atDistance: textAreaHeight, from: .maxYEdge)
        
        // Place the caption centered inside the text area, with margin
        if let caption {
            let textAreaMargin = (rect.width - (rect.width * self.layout.screenshotSizeFactor)) / 2
            let textArea = middleArea.insetBy(dx: textAreaMargin, dy: 0)
            drawText(caption, in: textArea, context: context)
        }
        
        // Place one half of the screenshot above the caption
        drawImage(screenshot, in: topArea, verticalAlignment: .bottom, context: context)
        
        // Place the other half of the screenshot below the caption
        drawImage(screenshot, in: bottomArea, verticalAlignment: .top, context: context)
    }
    
    /// Draws the screenshot centered inside the given rectangle, omitting any caption.
    ///
    /// - Parameters:
    ///   - rect: The rectangle to cover with caption and screenshot.
    ///   - screenshot: The screenshot to draw.
    ///   - context: The graphics context.
    ///
    private func drawLayoutScreenshotOnly(in rect: CGRect, screenshot: CGImage, context: CGContext) {
        drawImage(screenshot, in: rect, verticalAlignment: .middle, context: context)
    }

    /// Draws the given image in reduced size, aligned to the top or bottom edge of the given area or centered in the middle,
    /// including an optional shadow and optionally clipped to rounded corners.
    ///
    /// - Parameters:
    ///   - image: The image to draw.
    ///   - area: The area to use.
    ///   - verticalAlignment: The vertical alignment of the image inside the area.
    ///   - context: The graphics context.
    ///
    private func drawImage(_ image: CGImage, in area: CGRect, verticalAlignment: VerticalAlignment, context: CGContext) {
        
        // Reduce image size
        let reducedWidth = Double(image.width) * self.layout.screenshotSizeFactor
        let reducedHeight = Double(image.height) * self.layout.screenshotSizeFactor
        let reducedSize = CGSize(width: reducedWidth, height: reducedHeight)
        let cornerRadius = self.layout.screenshotCornerRadius * CGFloat(deviceScale(context.width))
        let shadowSize = self.layout.screenshotShadowSize * CGFloat(deviceScale(context.width))
        let shadowColor = self.layout.screenshotShadowColor
        let borderSize = self.layout.screenshotBorderSize * CGFloat(deviceScale(context.width))
        let borderColor = self.layout.screenshotBorderColor
        
        // Center the image horizontally
        let imagePosX = area.midX - (reducedWidth / 2)
        
        // Align the image vertically
        let imagePosY: CGFloat
        switch verticalAlignment {
        case .top:
            imagePosY = area.maxY - reducedHeight - borderSize
        case .middle:
            imagePosY = area.midY - (reducedHeight / 2)
        case .bottom:
            imagePosY = area.minY + borderSize
        }
        
        // Prepare the original image rect and a rendering definition that considers the rounded corners
        let imageRect = CGRect(x: imagePosX, y: imagePosY, width: reducedSize.width, height: reducedSize.height)
        let imageRectRendering = RectangleRendering(cornerRadius: cornerRadius)
        
        // Prepare another rect for applying the border and shadow, also considering the rounded corners.
        // If only a shadow is rendered, this rect is slightly smaller to avoid artifacts at the screenshot edges.
        let borderRelatedCornerRadius = cornerRadius + borderSize
        let borderOrShadowInset = borderSize > 0 ? -borderSize : 1
        let borderAndShadowRect = imageRect.insetBy(dx: borderOrShadowInset, dy: borderOrShadowInset)
        let borderAndShadowRectRendering = RectangleRendering(fillColor: borderColor, cornerRadius: borderRelatedCornerRadius, shadowSize: shadowSize, shadowColor: shadowColor)
        
        // Draw the border and shadow in a first pass behind the image.
        // Otherwise it would be clipped away, if drawn inside the clipped image range.
        borderAndShadowRectRendering.draw(in: borderAndShadowRect, context: context)
        
        // Draw image to the context, that is optionally clipped to the rounded corners of the image
        let imageRendering = ImageRendering(image: image, scaling: .mode(.stretchFill))
        context.saveGState()
        imageRectRendering.clip(to: imageRect, context: context)
        imageRendering.draw(in: imageRect, context: context)
        context.restoreGState()
    }
    
    /// Draws the given text inside the given area.
    ///
    /// - Parameters:
    ///   - text: The text to draw.
    ///   - area: The area to use.
    ///   - context: The graphics context.
    ///
    private func drawText(_ text: String, in area: CGRect, context: CGContext) {
        
        // Prepare the rendering attributes
        let color = self.layout.captionColor
        let fontName = self.layout.captionFontName
        let fontStyle = self.layout.captionFontStyle
        let fontSize = self.layout.captionFontSize * deviceScale(context.width)
        let horizontalAlignment = self.layout.captionAlignment
        let verticalAlignment = VerticalAlignment.middle
        
        // Render the text
        let textRendering = TextRendering(text: text, color: color, fontName: fontName, fontStyle: fontStyle, fontSize: fontSize, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment)
        textRendering.draw(in: area, context: context)
    }
    
    /// Guesses the scaling factor (e.g. @2x, @3x) based on the pixel size of the image.
    ///
    /// Following pixel sizes have been introduced with different iPhone generations,
    /// regarding the physical width in portrait mode (since iPhone model):
    ///
    /// __3x__
    /// - 1290 px (iPhone 14 Pro Max)
    /// - 1179 px (iPhone 14 Pro)
    /// - 1284 px (iPhone 12 Pro Max)
    /// - 1170 px (iPhone 12 Pro)
    /// - 1242 px (iPhone Xs Max)
    /// - 1125 px (iPhone X)
    /// - 1080 px (iPhone 6 Plus)
    ///
    /// __2x__
    /// - 828 px (iPhone Xr)
    /// - 750 px (iPhone 6)
    /// - 640 px (iPhone 4)
    ///
    /// __1x__
    /// - 320 px (original iPhone)
    ///
    /// - Note: See also https://www.ios-resolution.com
    ///
    /// - Returns: The scale factor, i.e. 1, 2 or 3.
    ///
    private func deviceScale(_ width: Int) -> Int {
        if width > 1000 {
            return 3
        } else if width > 320 {
            return 2
        } else {
            return 1
        }
    }
}
