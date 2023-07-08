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
    private let color: ColorType
    
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

    /// Rotation support.
    private let rotation: RotationSupport

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
    ///   - rotation: Rotation angle of the text. (Default: none)
    ///
    public init(text: String, color: ColorType, fontName: String, fontStyle: String, fontSize: Int, horizontalAlignment: HorizontalTextAlignment, verticalAlignment: VerticalAlignment, rotation: Angle = .zero) {
        self.text = text
        self.color = color
        self.fontName = fontName
        self.fontStyle = fontStyle
        self.fontSize = fontSize
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.rotation = RotationSupport(angle: rotation)
    }
    
    /// Draws the text inside the given rectangle.
    ///
    /// - Parameters:
    ///   - rect: The rectangle to use.
    ///   - context: The graphics context.
    ///
    public func draw(in rect: CGRect, context: CGContext) {
        
        // Pre-calculate the actual area that is needed to draw the text.
        // This is necessary if a gradient shall be used as color, because the pattern
        // drawing logic needs to be defined for a specific area that shall be covered.
        let actualTextRect = resolveActualTextRect(in: rect)

        // We could use a pattern based color also for solid colors, but to avoid
        // overhead, we use the patterns only for gradients.
        let textColor: CGColor
        switch self.color {
        case .solid(let color):
            textColor = color.CGColor
        default:
            textColor = try! createPatternBasedColor(for: actualTextRect, fillColor: self.color)
        }

        // Create an attributed string with defined font, paragraph settings and color (maybe a gradient)
        let font = createFont(name: self.fontName, size: self.fontSize, style: self.fontStyle)
        let paragraphStyle = createParagraphStyle(alignment: self.horizontalAlignment)
        let attributes: [CFString : Any] = [
            kCTFontAttributeName : font,
            kCTForegroundColorAttributeName : textColor,
            kCTParagraphStyleAttributeName : paragraphStyle
        ]
        let attributedString = CFAttributedStringCreate(kCFAllocatorDefault, text as CFString, attributes as CFDictionary)!

        // Draw the text inside the calculated frame, optionally rotated
        rotation.rotate(rect: actualTextRect, context: context) { rect, context in
            context.saveGState()
            let path = CGMutablePath()
            path.addRect(rect)
            let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
            let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
            CTFrameDraw(frame, context)
            context.restoreGState()
        }
    }

    /// Calculates the actual text position to use inside the given rectangle by letting a CoreText framesetter
    /// calculate the suggested frame size of the text for the defined font and paragraph style.
    ///
    /// - Parameter rect: The available space to use.
    /// - Returns: The actual rectangle that will be used for drawing the text.
    ///
    private func resolveActualTextRect(in rect: CGRect) -> CGRect {
        
        // Create an attributed string with defined font and paragraph settings (i.e. no color yet)
        let font = createFont(name: self.fontName, size: self.fontSize, style: self.fontStyle)
        let paragraphStyle = createParagraphStyle(alignment: self.horizontalAlignment)
        let attributes: [CFString : Any] = [
            kCTFontAttributeName : font,
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
        
        // Span the whole available width, but only the actual vertical space to use
        return CGRect(x: rect.origin.x, y: textPosY, width: rect.width, height: actualTextSize.height)
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
    
    /// Creates a `CGColor` instance that is backed by custom pattern drawing logic. The drawing logic uses
    /// the `RectangleRendering` class internally, which for example enables to draw gradients.
    ///
    /// - Parameters:
    ///   - rect: The area that shall be filled by the drawing logic.
    ///   - fillColor: The color (i.e. gradient definition) that shall be used for drawing.
    /// - Returns: The `CGColor` with the defined pattern drawing logic.
    ///
    private func createPatternBasedColor(for rect: CGRect, fillColor: ColorType) throws -> CGColor {
        
        // Wrap all needed data inside the context helper
        let renderer = RectangleRendering(fillColor: fillColor)
        let renderContext = PatternRenderContext(rect: rect, renderer: renderer)
        
        // The custom pattern
        guard let pattern = createPattern(renderContext: renderContext) else {
            throw RuntimeError("Could not create CGPattern.")
        }
        
        // Default pattern color space
        guard let patternSpace = CGColorSpace(patternBaseSpace: nil) else {
            throw RuntimeError("Could not create pattern based CGColorSpace.")
        }
        
        // The `CGColor` wrapping the pattern
        let alpha: CGFloat = 1.0
        let patternBasedColor = withUnsafePointer(to: alpha) { alphaPointer in
            return CGColor(patternSpace: patternSpace, pattern: pattern, components: alphaPointer)
        }
        guard let patternBasedColor else {
            throw RuntimeError("Could not create pattern based CGColor.")
        }
        
        return patternBasedColor
    }
    
    /// Creates a `CGPattern` that performs drawing logic by defining a `CGPatternCallbacks` implemenation,
    /// which uses the renderer of the given `PatternRenderContext` to fill the area of the given rectangle.
    ///
    /// Note: The implementation is based on the description from https://stackoverflow.com/a/44215903
    ///
    /// - Parameter renderContext: The context containing the renderer and rectangle.
    /// - Returns: The created pattern or `nil` if something went wrong.
    ///
    private func createPattern(renderContext: PatternRenderContext) -> CGPattern? {
        
        // Create the callback that performs the actual pattern drawing logic
        let callbacks = CGPatternCallbacks(version: 0, drawPattern: { (info, context) in
            
            // Everything needed here has to be provided through the `info` pointer
            let renderContext = Unmanaged<PatternRenderContext>.fromOpaque(info!).takeUnretainedValue()
            let renderer = renderContext.renderer
            let rect = renderContext.rect
            
            // Draw one tile of the pattern into graphics context
            renderer.draw(in: rect, context: context)
            
        }, releaseInfo: { (info) in
            // When the `CGPattern` is freed, release the +1 retain of the `info` pointer
            Unmanaged<PatternRenderContext>.fromOpaque(info!).release()
        })
        
        // The rectangle
        let rect = renderContext.rect
        
        // Passing `info` as +1 retained opaque pointer
        let unsafeInfo = Unmanaged.passRetained(renderContext).toOpaque()
        
        // Create the actual pattern
        let pattern = withUnsafePointer(to: callbacks) { callbacksPointer in
            return CGPattern(info: unsafeInfo, bounds: rect, matrix: .identity, xStep: rect.width, yStep: rect.height, tiling: .noDistortion, isColored: true, callbacks: callbacksPointer)
        }
        
        return pattern
    }
    
    /// Helper class to pass data as unmanaged `info` pointer to the `CGPatternCallbacks` structure.
    private class PatternRenderContext {
        
        let rect: CGRect
        let renderer: RectangleRendering
        
        init(rect: CGRect, renderer: RectangleRendering) {
            self.rect = rect
            self.renderer = renderer
        }
    }
}
