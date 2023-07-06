//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics
import UniformTypeIdentifiers

///
/// This action decorates a screenshot with a background and caption and returns the result as PNG image.
/// The appearance can be controlled by the settings of the configuration instance.
/// 
public struct DecorateAction {

    private let assets: DecorateActionAssets
    private let config: DecorateActionConfig
    
    /// Initializes this action instance.
    ///
    /// - Parameters:
    ///   - assets: The media and text assets that are used by the `decorate` action.
    ///   - config: The configured appearance settings of the `decorate` action.
    ///
    public init(assets: DecorateActionAssets, config: DecorateActionConfig) {
        self.assets = assets
        self.config = config
    }

    /// Runs this action and returns the result as PNG image.
    ///
    /// - Returns: The output image as PNG data.
    ///
    public func run() throws -> Data {
        
        let image: CGImage
        let context: CGContext
        
        if let screenshotImageData = self.assets.screenshot {
            // Read the input image and create a graphics context with same size
            image = try screenshotImageData.createCGImage()
            context = try image.createCGContext()
        } else {
            throw RuntimeError("Screenshot asset not defined.")
        }

        // Calculate total area and cover it with a background color
        let totalArea = CGRect(x: 0, y: 0, width: image.width, height: image.height)
        try drawBackground(in: totalArea, context: context)
        
        // Perform further layout specific drawing
        switch self.config.layout.layoutType {
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
        let colorRendering = RectangleRendering(fillColor: self.config.background.backgroundColor)
        colorRendering.draw(in: rect, context: context)
        
        // optional background image
        if let backgroundImageData = self.assets.background {
            let image = try backgroundImageData.createCGImage()
            let imageRendering = ImageRendering(image: image,
                                                scaling: self.config.background.backgroundImageScaling,
                                                horizontalAlignment: self.config.background.backgroundImageAlignment.horizontal,
                                                verticalAlignment: self.config.background.backgroundImageAlignment.vertical)
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
        let textAreaHeight = rect.height * self.config.caption.captionSizeFactor
        let (topArea, bottomArea) = rect.divided(atDistance: textAreaHeight, from: .maxYEdge)
        
        // Place the caption centered inside the text area, with margin
        if let caption = self.assets.caption {
            let textAreaMargin = (rect.width - (rect.width * self.config.screenshot.screenshotSizeFactor)) / 2
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
        let textAreaHeight = rect.height * self.config.caption.captionSizeFactor
        let (topArea, bottomArea) = rect.divided(atDistance: rect.height - textAreaHeight, from: .maxYEdge)
        
        // Place the caption centered inside the text area, with margin
        if let caption = self.assets.caption {
            let textAreaMargin = (rect.width - (rect.width * self.config.screenshot.screenshotSizeFactor)) / 2
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
        let textAreaHeight = rect.height * self.config.caption.captionSizeFactor
        let halfImageAreaHeight = (rect.height - textAreaHeight) / 2
        let (topArea, remainingRect) = rect.divided(atDistance: halfImageAreaHeight, from: .maxYEdge)
        
        // Second, divide remaining rect after height of text area, so we get:
        // - topArea:    half image
        // - middleArea: text
        // - bottomArea: half image
        let (middleArea, bottomArea) = remainingRect.divided(atDistance: textAreaHeight, from: .maxYEdge)
        
        // Place the caption centered inside the text area, with margin
        if let caption = self.assets.caption {
            let textAreaMargin = (rect.width - (rect.width * self.config.screenshot.screenshotSizeFactor)) / 2
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
        let reducedWidth = Double(image.width) * self.config.screenshot.screenshotSizeFactor
        let reducedHeight = Double(image.height) * self.config.screenshot.screenshotSizeFactor
        let reducedSize = CGSize(width: reducedWidth, height: reducedHeight)
        let cornerRadius = self.config.screenshot.screenshotCornerRadius * CGFloat(deviceScale(context.width))
        let shadowSize = self.config.screenshot.screenshotShadowSize * CGFloat(deviceScale(context.width))
        let shadowColor = self.config.screenshot.screenshotShadowColor
        let borderSize = self.config.screenshot.screenshotBorderSize * CGFloat(deviceScale(context.width))
        let borderColor = self.config.screenshot.screenshotBorderColor
        
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
        
        // Prepare the original image rect
        let imageRect = CGRect(x: imagePosX, y: imagePosY, width: reducedSize.width, height: reducedSize.height)

        // Prepare another rect for applying the border and shadow, also considering the rounded corners.
        // If only a shadow is rendered, this rect is slightly smaller to avoid artifacts at the screenshot edges.
        let borderRelatedCornerRadius = cornerRadius + borderSize
        let borderOrShadowInset = borderSize > 0 ? -borderSize : 1
        let borderAndShadowRect = imageRect.insetBy(dx: borderOrShadowInset, dy: borderOrShadowInset)
        let borderAndShadowRectRendering = RectangleRendering(fillColor: borderColor, cornerRadius: borderRelatedCornerRadius, shadowSize: shadowSize, shadowColor: shadowColor)
        
        // Draw the border and shadow in a first pass behind the image.
        // Otherwise it would be clipped away, if drawn inside the clipped image range.
        borderAndShadowRectRendering.draw(in: borderAndShadowRect, context: context)
        
        // Draw image to the context
        let imageRendering = ImageRendering(image: image, scaling: .mode(.stretchFill), cornerRadius: cornerRadius)
        imageRendering.draw(in: imageRect, context: context)
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
        let color = self.config.caption.captionColor
        let fontName = self.config.caption.captionFontName
        let fontStyle = self.config.caption.captionFontStyle
        let fontSize = self.config.caption.captionFontSize * deviceScale(context.width)
        let horizontalAlignment = self.config.caption.captionAlignment
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
