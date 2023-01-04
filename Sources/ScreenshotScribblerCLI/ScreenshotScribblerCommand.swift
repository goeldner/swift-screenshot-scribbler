//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
import CoreGraphics
import CoreText
import ScreenshotScribbler

///
/// Command line interface of the `ScreenshotScribbler` library.
///
@main
struct ScreenshotScribblerCommand: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "scrscr",
        abstract: "Creates a new image with same dimensions as a given screenshot, adds a background, reduces the size of the original screenshot, places it nicely and scribbles a caption next to it.",
        version: "1.0.0"
    )

    @OptionGroup(title: "Basic")
    var basicOptions: BasicOptions
    
    @OptionGroup(title: "Background style")
    var backgroundStyleOptions: BackgroundStyleOptions
    
    @OptionGroup(title: "Caption style")
    var captionStyleOptions: CaptionStyleOptions

    @OptionGroup(title: "Screenshot style")
    var screenshotStyleOptions: ScreenshotStyleOptions
    
    @Flag(name: .long, help: "Show detailed progress updates.")
    var verbose = false

    struct BasicOptions: ParsableCommand {
        
        @Option(name: .long, help: "The caption to scribble. (Optional)")
        var caption: String?
        
        @Option(name: .customLong("screenshot"), help: "The screenshot image file to read. (Required)")
        var screenshotFile: String
        
        @Option(name: .customLong("output"), help: "The output image file to write. (Required)")
        var outputFile: String
        
        @Option(name: .customLong("layout"), help: "Arrangement of the caption and screenshot. (Default: \"\(LayoutType.captionBeforeScreenshot.rawValue)\"; Options: \"\(LayoutType.captionAfterScreenshot.rawValue)\", \"\(LayoutType.captionBetweenScreenshots.rawValue)\", \"\(LayoutType.screenshotOnly.rawValue)\")", transform: transformLayoutType)
        var layoutType: LayoutType?
        
    }
    
    struct BackgroundStyleOptions: ParsableCommand {
        
        @Option(name: .long, help: "Color which covers the whole background. (Default: \"#FFFFFF\" (white); Supports gradients)", transform: transformColorType)
        var backgroundColor: ColorType?
        
    }
    
    struct CaptionStyleOptions: ParsableCommand {
        
        @Option(name: .long, help: "Percentage of the caption area height relative to the total height of the output image. (Default: 0.25 (25%))")
        var captionSizeFactor: Double?
        
        @Option(name: .long, help: "Horizontal alignment of the caption. (Default: \"center\"; Options: \"left\", \"right\", \"justified\")", transform: transformTextAlignment)
        var captionAlignment: CTTextAlignment?
        
        @Option(name: .long, help: "Color of the caption. (Default: \"#000000\" (black))", transform: transformColor)
        var captionColor: CGColor?
        
        @Option(name: .long, help: "Font family name of the caption. (Default: \"SF Compact\")")
        var captionFontName: String?
        
        @Option(name: .long, help: "Font style of the caption. (Default: \"Bold\")")
        var captionFontStyle: String?
        
        @Option(name: .long, help: "Font size of the caption. (Default: 32)")
        var captionFontSize: Int?
        
    }
    
    struct ScreenshotStyleOptions: ParsableCommand {
        
        @Option(name: .long, help: "Percentage of the rendered screenshot size relative to its original size. (Default: 0.85 (85%))")
        var screenshotSizeFactor: Double?
        
        @Option(name: .long, help: "Corner radius of the screenshot. (Default: 5)")
        var screenshotCornerRadius: Double?
        
        @Option(name: .long, help: "Size of the shadow blur behind the screenshot. (Default: 5)")
        var screenshotShadowSize: Double?
        
        @Option(name: .long, help: "Color of the shadow behind the screenshot. (Default: \"#000000\" (black))", transform: transformColor)
        var screenshotShadowColor: CGColor?

        @Option(name: .long, help: "Size of the border around the screenshot. (Default: 0)")
        var screenshotBorderSize: Double?
        
        @Option(name: .long, help: "Color of the border around the screenshot. (Default: \"#000000\" (black); Supports gradients)", transform: transformColorType)
        var screenshotBorderColor: ColorType?
        
    }
    
    func run() throws {

        // Read data of input file
        print("Screenshot: \(self.basicOptions.screenshotFile)")
        let screenshotUrl = URL(fileURLWithPath: self.basicOptions.screenshotFile)
        if verbose {
            print(" => \(screenshotUrl)")
        }
        guard let screenshotData = try? Data(contentsOf: screenshotUrl) else {
            throw RuntimeError("Could not read from: \(screenshotUrl)")
        }
        
        // Parse the layout configuration options
        let layoutConfig = parseLayoutOptions()
        
        // Generate the new image
        if verbose {
            print("Generating output image...")
        }
        let caption = self.basicOptions.caption
        let scrscr = ScreenshotScribbler(screenshot: screenshotData, caption: caption, layout: layoutConfig)
        let output = try scrscr.generate()

        // Write data to output file
        print("Output: \(self.basicOptions.outputFile)")
        let outputUrl = URL(fileURLWithPath: self.basicOptions.outputFile)
        if verbose {
            print(" => \(outputUrl)")
        }
        guard let _ = try? output.write(to: outputUrl, options: .atomic) else {
            throw RuntimeError("Could not write to: \(outputUrl)")
        }
        
        if verbose {
            print("Success")
        }
    }
    
    private func parseLayoutOptions() -> LayoutConfig {
        var layout = LayoutConfig()
        // Layout type
        if let layoutType = self.basicOptions.layoutType {
            layout.layoutType = layoutType
        }
        // Background style options
        if let backgroundColor = self.backgroundStyleOptions.backgroundColor {
            layout.backgroundColor = backgroundColor
        }
        // Caption style options
        if let captionSizeFactor = self.captionStyleOptions.captionSizeFactor {
            layout.captionSizeFactor = captionSizeFactor
        }
        if let captionAlignment = self.captionStyleOptions.captionAlignment {
            layout.captionAlignment = captionAlignment
        }
        if let captionColor = self.captionStyleOptions.captionColor {
            layout.captionColor = captionColor
        }
        if let captionFontName = self.captionStyleOptions.captionFontName {
            layout.captionFontName = captionFontName
        }
        if let captionFontStyle = self.captionStyleOptions.captionFontStyle {
            layout.captionFontStyle = captionFontStyle
        }
        if let captionFontSize = self.captionStyleOptions.captionFontSize {
            layout.captionFontSize = captionFontSize
        }
        // Screenshot style options
        if let screenshotSizeFactor = self.screenshotStyleOptions.screenshotSizeFactor {
            layout.screenshotSizeFactor = screenshotSizeFactor
        }
        if let screenshotCornerRadius = self.screenshotStyleOptions.screenshotCornerRadius {
            layout.screenshotCornerRadius = screenshotCornerRadius
        }
        if let screenshotShadowSize = self.screenshotStyleOptions.screenshotShadowSize {
            layout.screenshotShadowSize = screenshotShadowSize
        }
        if let screenshotShadowColor = self.screenshotStyleOptions.screenshotShadowColor {
            layout.screenshotShadowColor = screenshotShadowColor
        }
        if let screenshotBorderSize = self.screenshotStyleOptions.screenshotBorderSize {
            layout.screenshotBorderSize = screenshotBorderSize
        }
        if let screenshotBorderColor = self.screenshotStyleOptions.screenshotBorderColor {
            layout.screenshotBorderColor = screenshotBorderColor
        }
        return layout
    }
    
    private static func transformLayoutType(_ string: String) throws -> LayoutType {
        if string == LayoutType.captionBeforeScreenshot.rawValue {
            return .captionBeforeScreenshot
        } else if string == LayoutType.captionAfterScreenshot.rawValue {
            return .captionAfterScreenshot
        } else if string == LayoutType.captionBetweenScreenshots.rawValue {
            return .captionBetweenScreenshots
        } else if string == LayoutType.screenshotOnly.rawValue {
            return .screenshotOnly
        } else {
            throw RuntimeError("Unsupported layout type: \(string)")
        }
    }
    
    private static func transformTextAlignment(_ string: String) throws -> CTTextAlignment {
        if string == "center" {
            return .center
        } else if string == "left" {
            return .left
        } else if string == "right" {
            return .right
        } else if string == "justified" {
            return .justified
        } else {
            throw RuntimeError("Unsupported text alignment: \(string)")
        }
    }
    
    private static func transformColorType(_ string: String) throws -> ColorType {
        let colorParser = ColorParser()
        if colorParser.isHexColor(string) {
            return .solid(color: try colorParser.parseHexColor(string))
        }
        if colorParser.isGradient(string) {
            return try colorParser.parseGradient(string)
        }
        throw RuntimeError("Unsupported color format: \(string)")
    }
    
    private static func transformColor(_ string: String) throws -> CGColor {
        let colorParser = ColorParser()
        if colorParser.isHexColor(string) {
            return try colorParser.parseHexColor(string)
        }
        throw RuntimeError("Unsupported color format: \(string)")
    }
    
}
