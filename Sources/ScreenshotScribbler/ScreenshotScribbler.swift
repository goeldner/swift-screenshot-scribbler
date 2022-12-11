//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreText
import ImageIO

public struct ScreenshotScribbler {

    private let caption: String
    private let input: Data
    private let layout: LayoutConfig

    /// Initializes the screenshot scribbler with an input image and caption.
    ///
    /// - Parameters:
    ///   - input: The input image in PNG data format.
    ///   - caption: The caption to display besides the screenshot.
    ///   - layout: The layout configuration (optional).
    ///
    public init(input: Data, caption: String, layout: LayoutConfig = LayoutConfig()) {
        self.input = input
        self.caption = caption
        self.layout = layout
    }

    /// Generates the output image based on the configured input image, caption and layout settings.
    ///
    /// - Returns: The output image as PNG data.
    ///
    public func generate() throws -> Data {
        
        // Read the input PNG image data
        let cgImage = try createImage(fromPNG: self.input)
        
        // Create graphics context with same size as input PNG
        let colorSpace = cgImage.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!
        guard let context = CGContext(data: nil, width: cgImage.width, height: cgImage.height, bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else {
            throw RuntimeError("Error initializing CGContext")
        }
        
        // Currently only one layout implemented
        if self.layout.layoutType != LayoutType.textBeforeImage {
            throw RuntimeError("Layout type not implemented yet: \(self.layout.layoutType)")
        }
        
        // Calculate areas
        let totalArea = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
        let (topArea, bottomArea) = totalArea.divided(atDistance: totalArea.height * self.layout.textAreaRatio, from: .maxYEdge)
        let textAreaMargin = (totalArea.width - (totalArea.width * self.layout.imageSizeReduction)) / 2
        let textArea = topArea.insetBy(dx: textAreaMargin, dy: 0)
        
        // Cover the whole area with a background color
        drawRect(totalArea, color: self.layout.backgroundColor, context: context)
        //drawRect(topArea, color: CGColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0), context: context)
        //drawRect(textArea, color: CGColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0), context: context)
        //drawRect(bottomArea, color: CGColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0), context: context)
        
        // Place the caption centered inside the top area
        drawText(caption, in: textArea, context: context)
        
        // Reduce size of screenshot and add it below the caption
        drawImage(cgImage, in: bottomArea, context: context)
        
        // Generate output PNG
        let outputImageData = try createPNG(context)
        return outputImageData
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
    
    /// Draws the given image in reduced size aligned to the top of the given area.
    ///
    /// - Parameters:
    ///   - image: The image to draw.
    ///   - area: The area to use.
    ///   - context: The graphics context.
    ///
    private func drawImage(_ image: CGImage, in area: CGRect, context: CGContext) {
        context.saveGState()
        
        // Reduce image size
        let reducedWidth = Double(image.width) * self.layout.imageSizeReduction
        let reducedHeight = Double(image.height) * self.layout.imageSizeReduction
        let reducedSize = CGSize(width: reducedWidth, height: reducedHeight)
        let shadowSize = self.layout.shadowSize * CGFloat(deviceScale(context.width))
        
        // Center the image horizontally
        let centerX = area.width / 2
        let newPosX = centerX - (reducedWidth / 2)
        
        // Place the top image position at the top begin of the area
        let newPosY = area.maxY - reducedHeight - shadowSize
        
        // Draw image with a shadow
        context.setShadow(offset: CGSize(width: 0, height: 0), blur: shadowSize, color: self.layout.shadowColor)
        context.draw(image, in: CGRect(origin: CGPoint(x: newPosX, y: newPosY), size: reducedSize))
        
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
        let fontSize = self.layout.fontSize * deviceScale(context.width)
        let font = createFont(name: self.layout.fontName, size: fontSize, style: self.layout.fontStyle)
        
        // Create a centered paragraph
        let paragraphStyle = createParagraphStyle(alignment: .center)
        
        // Create an attributed string with that font, color and paragraph settings
        let attributes: [CFString : Any] = [
            kCTFontAttributeName : font,
            kCTForegroundColorAttributeName : self.layout.textColor,
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
        guard let outputImageDestination = CGImageDestinationCreateWithData(unlimitedMutableData, kUTTypePNG, 1, nil) else {
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
