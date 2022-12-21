//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreText
import ImageIO
import UniformTypeIdentifiers

public struct ScreenshotScribbler {

    private let screenshot: Data
    private let caption: String
    private let layout: LayoutConfig

    /// Initializes the screenshot scribbler with a screenshot image and caption.
    ///
    /// - Parameters:
    ///   - screenshot: The screenshot image in PNG data format.
    ///   - caption: The caption to display next to the screenshot.
    ///   - layout: The layout configuration (optional).
    ///
    public init(screenshot: Data, caption: String, layout: LayoutConfig = LayoutConfig()) {
        self.screenshot = screenshot
        self.caption = caption
        self.layout = layout
    }

    /// Generates the output image based on the configured screenshot image, caption and layout settings.
    ///
    /// - Returns: The output image as PNG data.
    ///
    public func generate() throws -> Data {
        
        // Read the input PNG image data
        let cgImage = try createImage(fromPNG: self.screenshot)
        
        // Create graphics context with same size as input PNG
        let colorSpace = cgImage.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!
        guard let context = CGContext(data: nil, width: cgImage.width, height: cgImage.height, bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else {
            throw RuntimeError("Error initializing CGContext")
        }
        
        // Calculate total area and cover it with a background color
        let totalArea = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
        drawRect(totalArea, color: self.layout.backgroundColor, context: context)
        
        // Perform further layout specific drawing
        switch self.layout.layoutType {
        case .captionBeforeScreenshot:
            drawLayoutCaptionBeforeScreenshot(in: totalArea, screenshot: cgImage, context: context)
        case .captionAfterScreenshot:
            drawLayoutCaptionAfterScreenshot(in: totalArea, screenshot: cgImage, context: context)
        case .captionBetweenScreenshots:
            drawLayoutCaptionBetweenScreenshots(in: totalArea, screenshot: cgImage, context: context)
        }
        
        // Generate output PNG
        let outputImageData = try createPNG(context)
        return outputImageData
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
        let textAreaMargin = (rect.width - (rect.width * self.layout.screenshotSizeFactor)) / 2
        let textArea = topArea.insetBy(dx: textAreaMargin, dy: 0)
        drawText(caption, in: textArea, context: context)
        
        // Place the screenshot below the caption
        let imageArea = bottomArea
        let imageAtTopEdgeOfArea = true
        drawImage(screenshot, in: imageArea, atTopEdge: imageAtTopEdgeOfArea, context: context)
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
        let textAreaMargin = (rect.width - (rect.width * self.layout.screenshotSizeFactor)) / 2
        let textArea = bottomArea.insetBy(dx: textAreaMargin, dy: 0)
        drawText(caption, in: textArea, context: context)
        
        // Place the screenshot above the caption
        let imageArea = topArea
        let imageAtTopEdgeOfArea = false
        drawImage(screenshot, in: imageArea, atTopEdge: imageAtTopEdgeOfArea, context: context)
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
        let textAreaMargin = (rect.width - (rect.width * self.layout.screenshotSizeFactor)) / 2
        let textArea = middleArea.insetBy(dx: textAreaMargin, dy: 0)
        drawText(caption, in: textArea, context: context)
        
        // Place one half of the screenshot above the caption
        let image1Area = topArea
        let image1AtTopEdgeOfArea = false
        drawImage(screenshot, in: image1Area, atTopEdge: image1AtTopEdgeOfArea, context: context)
        
        // Place the other half of the screenshot below the caption
        let image2Area = bottomArea
        let image2AtTopEdgeOfArea = true
        drawImage(screenshot, in: image2Area, atTopEdge: image2AtTopEdgeOfArea, context: context)
    }
    
    /// Draws the given rectancle in given color.
    ///
    /// - Parameters:
    ///   - rect: The rectangle to draw.
    ///   - color: The color to use.
    ///   - context: The graphics context.
    ///
    private func drawRect(_ rect: CGRect, color: CGColor, context: CGContext) {
        context.saveGState()
        
        context.addRect(rect)
        context.setFillColor(color)
        context.setStrokeColor(color)
        context.drawPath(using: .fillStroke)
        
        context.restoreGState()
    }
    
    /// Draws the given image in reduced size aligned to the top or bottom edge of the given area,
    /// including an optional shadow and optionally clipped to rounded corners.
    ///
    /// - Parameters:
    ///   - image: The image to draw.
    ///   - area: The area to use.
    ///   - atTopEdge: true if image top edge shall be aligned to top edge of area; false for bottom alignment
    ///   - context: The graphics context.
    ///
    private func drawImage(_ image: CGImage, in area: CGRect, atTopEdge: Bool, context: CGContext) {
        
        // Reduce image size
        let reducedWidth = Double(image.width) * self.layout.screenshotSizeFactor
        let reducedHeight = Double(image.height) * self.layout.screenshotSizeFactor
        let reducedSize = CGSize(width: reducedWidth, height: reducedHeight)
        let shadowSize = self.layout.screenshotShadowSize * CGFloat(deviceScale(context.width))
        let cornerRadius = self.layout.screenshotCornerRadius * CGFloat(deviceScale(context.width))
        
        // Center the image horizontally
        let centerX = area.width / 2
        let imagePosX = centerX - (reducedWidth / 2)
        
        // Align the top edge of the image to the top edge of the area; otherwise bottom to bottom
        let imagePosY: CGFloat
        if atTopEdge {
            imagePosY = area.maxY - reducedHeight - shadowSize
        } else {
            imagePosY = area.minY + shadowSize
        }
        
        // Prepare the original image rect to draw and one with clipped rounded corners
        let imageRect = CGRect(x: imagePosX, y: imagePosY, width: reducedSize.width, height: reducedSize.height)
        let imageRectWithCornerRadius = CGPath(roundedRect: imageRect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        let shadowRectWithCornerRadius = CGPath(roundedRect: imageRect.insetBy(dx: 1, dy: 1), cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        
        // Draw the shadow first behind the image, otherwise it would be clipped away, if drawn with the clipped image
        if shadowSize > 0 {
            context.saveGState()
            context.beginPath()
            context.addPath(shadowRectWithCornerRadius)
            context.closePath()
            context.setShadow(offset: CGSize(width: 0, height: 0), blur: shadowSize, color: self.layout.screenshotShadowColor)
            context.setFillColor(self.layout.backgroundColor)
            context.fillPath()
            context.restoreGState()
        }
        
        context.saveGState()
        
        // Clip the context to the rounded corners of the image
        if cornerRadius > 0 {
            context.beginPath()
            context.addPath(imageRectWithCornerRadius)
            context.closePath()
            context.clip()
        }
        
        // Draw image, optionally clipped to range defined above
        context.draw(image, in: imageRect)
        
        context.restoreGState()
    }
    
    /// Draws the given text horizontally and vertically centered inside the given area.
    ///
    /// - Parameters:
    ///   - text: The text to draw.
    ///   - area: The area to use.
    ///   - context: The graphics context.
    ///
    private func drawText(_ text: String, in area: CGRect, context: CGContext) {
        context.saveGState()
        
        // Create the font
        let fontColor = self.layout.captionColor
        let fontSize = self.layout.captionFontSize * deviceScale(context.width)
        let font = createFont(name: self.layout.captionFontName, size: fontSize, style: self.layout.captionFontStyle)
        
        // Create a paragraph style with text alignment
        let paragraphStyle = createParagraphStyle(alignment: self.layout.captionAlignment)
        
        // Create an attributed string with that font, color and paragraph settings
        let attributes: [CFString : Any] = [
            kCTFontAttributeName : font,
            kCTForegroundColorAttributeName : fontColor,
            kCTParagraphStyleAttributeName : paragraphStyle
        ]
        let attributedString = CFAttributedStringCreate(kCFAllocatorDefault, text as CFString, attributes as CFDictionary)!
        
        // Calculate the frame where the text will be drawn by inspecting its actual required size
        // and shifting the frame accordingly, so that the text will be vertically centered inside the given area
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let actualTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, area.size, nil)
        let textPosY = area.origin.y + (area.height / 2) - (actualTextSize.height / 2)
        let path = CGMutablePath()
        path.addRect(CGRect(x: area.origin.x, y: textPosY, width: area.width, height: actualTextSize.height))
        
        // Draw the text inside the calculated frame
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        CTFrameDraw(frame, context)
        
        context.restoreGState()
    }
    
    /// Creates a CoreText font with given font family name, size and style by using CoreText APIs only.
    ///
    /// - Parameters:
    ///   - name: Font family name.
    ///   - size: Font size.
    ///   - style: Font style, e.g. "Regular" or "Bold".
    /// - Returns: The CoreText font.
    ///
    private func createFont(name: String, size: Int, style: String) -> CTFont {
        
        let ctFontAttributes: [CFString : Any] = [
            kCTFontFamilyNameAttribute : name as CFString,
            kCTFontStyleNameAttribute : style as CFString,
            kCTFontSizeAttribute : CGFloat(size)
        ]
        
        let ctFontDescriptor = CTFontDescriptorCreateWithAttributes(ctFontAttributes as CFDictionary)
        let ctFont = CTFontCreateWithFontDescriptor(ctFontDescriptor, 0.0, nil)
        
        return ctFont
    }
    
    /// Creates a CoreText paragraph style with given alignment by using CoreText APIs only.
    ///
    /// - Parameter alignment: The alignment.
    /// - Returns: The CoreText paragraph style.
    ///
    private func createParagraphStyle(alignment: CTTextAlignment) -> CTParagraphStyle {
        withUnsafePointer(to: alignment) { alignmentPointer in
            
            let ctParagraphAlignment: CTParagraphStyleSetting = CTParagraphStyleSetting(
                spec: CTParagraphStyleSpecifier.alignment,
                valueSize: MemoryLayout<CTTextAlignment>.size,
                value: alignmentPointer)
            
            let ctParagraphSettings: [CTParagraphStyleSetting] = [
                ctParagraphAlignment
            ]
            
            let ctParagraphStyle = CTParagraphStyleCreate(ctParagraphSettings, ctParagraphSettings.count)
            
            return ctParagraphStyle
        }
    }
    
    /// Creates a CoreGraphics image based on the given PNG data.
    ///
    /// - Parameter data: The data in PNG format.
    /// - Returns: The CoreGraphics image.
    /// - Throws: `RuntimeError` if one of the transformation steps fails.
    ///
    private func createImage(fromPNG data: Data) throws -> CGImage {
        guard let cgDataProvider = CGDataProvider(data: data as CFData) else {
            throw RuntimeError("Error initializing CGDataProvider")
        }
        guard let cgImage = CGImage(pngDataProviderSource: cgDataProvider, decode: nil, shouldInterpolate: true, intent: .defaultIntent) else {
            throw RuntimeError("Error initializing CGImage")
        }
        return cgImage
    }
    
    /// Generates a CoreGraphics image of the given graphics context and transforms it into PNG data.
    ///
    /// - Parameter context: The graphics context.
    /// - Returns: The PNG data.
    /// - Throws: `RuntimeError` if one of the transformation steps fails.
    ///
    private func createPNG(_ context: CGContext) throws -> Data {
        guard let outputImage = context.makeImage() else {
            throw RuntimeError("Error: CGContext.makeImage()")
        }
        guard let unlimitedMutableData = CFDataCreateMutable(nil, 0) else {
            throw RuntimeError("Error: CFDataCreateMutable")
        }
        let outputType = UTType.png.identifier as CFString
        guard let outputImageDestination = CGImageDestinationCreateWithData(unlimitedMutableData, outputType, 1, nil) else {
            throw RuntimeError("Error: CGImageDestinationCreateWithData")
        }
        CGImageDestinationAddImage(outputImageDestination, outputImage, nil)
        guard CGImageDestinationFinalize(outputImageDestination) else {
            throw RuntimeError("Error: CGImageDestinationFinalize")
        }
        let outputImageData = unlimitedMutableData as Data
        return outputImageData
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
