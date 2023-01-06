//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreText

///
/// Text rendering definition and drawing logic.
///
public class TextRendering {

    /// The text to draw.
    private let text: String
    
    /// Color of the text.
    private let color: CGColor
    
    /// Font family name of the text.
    private let fontName: String
    
    /// Font style of the text.
    private let fontStyle: String
    
    /// Font size of the text.
    private let fontSize: Int
    
    /// Horizontal alignment of the text.
    private let horizontalAlignment: HorizontalTextAlignment
    
    /// Vertical alignment of the text.
    private let verticalAlignment: VerticalAlignment
    
    /// Initializes the rendering definition.
    ///
    /// - Parameters:
    ///   - text: The text to draw.
    ///   - color: Color of the text.
    ///   - fontName: Font family name of the text.
    ///   - fontStyle: Font style of the text.
    ///   - fontSize: Font size of the text.
    ///   - horizontalAlignment: Horizontal alignment of the text.
    ///   - verticalAlignment: Vertical alignment of the text.
    ///
    public init(text: String, color: CGColor, fontName: String, fontStyle: String, fontSize: Int, horizontalAlignment: HorizontalTextAlignment, verticalAlignment: VerticalAlignment) {
        self.text = text
        self.color = color
        self.fontName = fontName
        self.fontStyle = fontStyle
        self.fontSize = fontSize
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
    }
    
    /// Draws the text inside the given rectangle.
    ///
    /// - Parameters:
    ///   - rect: The rectangle to use.
    ///   - context: The graphics context.
    ///
    public func draw(in rect: CGRect, context: CGContext) {
        context.saveGState()
        
        // Create the font
        let font = createFont(name: self.fontName, size: self.fontSize, style: self.fontStyle)
        
        // Create a paragraph style with text alignment
        let paragraphStyle = createParagraphStyle(alignment: self.horizontalAlignment)
        
        // Create an attributed string with that font, color and paragraph settings
        let attributes: [CFString : Any] = [
            kCTFontAttributeName : font,
            kCTForegroundColorAttributeName : self.color,
            kCTParagraphStyleAttributeName : paragraphStyle
        ]
        let attributedString = CFAttributedStringCreate(kCFAllocatorDefault, text as CFString, attributes as CFDictionary)!
        
        // Calculate the y-position where the text will be drawn by inspecting its actual required size
        // and shifting the frame accordingly, so that the text will be vertically aligned inside the given area.
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let actualTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, rect.size, nil)
        let textPosY: CGFloat
        switch verticalAlignment {
        case .top:
            textPosY = rect.maxY - actualTextSize.height
        case .middle:
            textPosY = rect.midY - (actualTextSize.height / 2)
        case .bottom:
            textPosY = rect.minY
        }
        
        // Draw the text inside the calculated frame
        let path = CGMutablePath()
        path.addRect(CGRect(x: rect.origin.x, y: textPosY, width: rect.width, height: actualTextSize.height))
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
    private func createParagraphStyle(alignment: HorizontalTextAlignment) -> CTParagraphStyle {
        
        let ctTextAlignment: CTTextAlignment = {
            switch alignment {
                case .left: return .left
                case .center: return .center
                case .right: return .right
                case .justified: return .justified
            }
        }()
        
        let result = withUnsafePointer(to: ctTextAlignment) { alignmentPointer in
            
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
        
        return result
    }
}
