//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
import CoreGraphics
import ScreenshotScribbler

@main
struct ScreenshotScribblerCommand: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "scrscr",
        abstract: "Creates a new image with same dimensions as a given screenshot, adds a background, reduces the size of the original screenshot, places it nicely and scribbles a caption besides it.",
        version: "1.0.0"
    )

    @OptionGroup(title: "Required")
    var inputOutputOptions: InputOutputOptions
    
    @OptionGroup(title: "Layout")
    var layoutOptions: LayoutOptions
    
    @OptionGroup(title: "Background style")
    var backgroundOptions: BackgroundOptions
    
    @OptionGroup(title: "Text style")
    var textOptions: TextOptions

    @OptionGroup(title: "Image style")
    var imageOptions: ImageOptions
    
    @Flag(name: .shortAndLong, help: "Show detailed progress updates.")
    var verbose = false

    struct InputOutputOptions: ParsableCommand {
        
        @Option(name: .long, help: "The caption to scribble.")
        var caption: String
        
        @Option(name: .customLong("input"), help: "The screenshot file to read.")
        var inputFile: String
        
        @Option(name: .customLong("output"), help: "The output image to write.")
        var outputFile: String
        
    }
    
    struct LayoutOptions: ParsableCommand {
        
        @Option(name: .long, help: "Arrangement of the text and image area. (Default: \"text-before-image\"; More options: \"text-after-image\", \"text-between-images\")", transform: transformLayoutType)
        var layoutType: LayoutType?
    
        @Option(name: .long, help: "Percentage of the text area inside the layout in vertical direction. (Default: 0.25 (25%))")
        var layoutTextRatio: Double?
        
    }
    
    struct BackgroundOptions: ParsableCommand {
        
        @Option(name: .long, help: "Color which covers the whole background. (Default: \"#FFFFFF\" (white))", transform: transformColor)
        var backgroundColor: CGColor?
        
    }
    
    struct TextOptions: ParsableCommand {
        
        @Option(name: .long, help: "Color of the rendered text. (Default: \"#000000\" (black))", transform: transformColor)
        var textColor: CGColor?
        
        @Option(name: .long, help: "Font family name. (Default: \"SF Compact\")")
        var fontName: String?
        
        @Option(name: .long, help: "Font style. (Default: \"Bold\")")
        var fontStyle: String?
        
        @Option(name: .long, help: "Font size. (Default: 32)")
        var fontSize: Int?
        
    }
    
    struct ImageOptions: ParsableCommand {
        
        @Option(name: .long, help: "Percentage of the screenshot in reduced size. (Default: 0.85 (85%))")
        var imageSizeReduction: Double?
        
        @Option(name: .long, help: "Corner radius of the screenshot. (Default: 5)")
        var imageCornerRadius: Double?
        
        @Option(name: .long, help: "Size of the shadow blur behind the screenshot. (Default: 5)")
        var imageShadowSize: Double?
        
        @Option(name: .long, help: "Color of the shadow behind the screenshot. (Default: \"#000000\" (black))", transform: transformColor)
        var imageShadowColor: CGColor?
    }
    
    func run() throws {

        // Read data of input file
        print("input: \(self.inputOutputOptions.inputFile)")
        let inputUrl = URL(fileURLWithPath: self.inputOutputOptions.inputFile)
        if verbose {
            print(" => \(inputUrl)")
        }
        guard let inputData = try? Data(contentsOf: inputUrl) else {
            throw RuntimeError("Could not read from: \(inputUrl)")
        }
        
        // Parse the layout configuration options
        let layoutConfig = parseLayoutOptions()
        
        // Generate the new image
        if verbose {
            print("generating image...")
        }
        let caption = self.inputOutputOptions.caption
        let scribbler = ScreenshotScribbler(input: inputData, caption: caption, layout: layoutConfig)
        let output = try scribbler.generate()

        // Write data to output file
        print("output: \(self.inputOutputOptions.outputFile)")
        let outputUrl = URL(fileURLWithPath: self.inputOutputOptions.outputFile)
        if verbose {
            print(" => \(outputUrl)")
        }
        guard let _ = try? output.write(to: outputUrl, options: .atomic) else {
            throw RuntimeError("Could not write to: \(outputUrl)")
        }
        
        if verbose {
            print("success")
        }
    }
    
    private func parseLayoutOptions() -> LayoutConfig {
        var layout = LayoutConfig()
        // Layout options
        if let layoutType = self.layoutOptions.layoutType {
            layout.layoutType = layoutType
        }
        if let layoutTextRatio = self.layoutOptions.layoutTextRatio {
            layout.layoutTextRatio = layoutTextRatio
        }
        // Background options
        if let backgroundColor = self.backgroundOptions.backgroundColor {
            layout.backgroundColor = backgroundColor
        }
        // Text options
        if let textColor = self.textOptions.textColor {
            layout.textColor = textColor
        }
        if let fontName = self.textOptions.fontName {
            layout.fontName = fontName
        }
        if let fontStyle = self.textOptions.fontStyle {
            layout.fontStyle = fontStyle
        }
        if let fontSize = self.textOptions.fontSize {
            layout.fontSize = fontSize
        }
        // Image options
        if let imageSizeReduction = self.imageOptions.imageSizeReduction {
            layout.imageSizeReduction = imageSizeReduction
        }
        if let imageCornerRadius = self.imageOptions.imageCornerRadius {
            layout.imageCornerRadius = imageCornerRadius
        }
        if let imageShadowSize = self.imageOptions.imageShadowSize {
            layout.imageShadowSize = imageShadowSize
        }
        if let imageShadowColor = self.imageOptions.imageShadowColor {
            layout.imageShadowColor = imageShadowColor
        }
        return layout
    }
    
    private static func transformLayoutType(_ string: String) throws -> LayoutType {
        if string == "text-before-image" {
            return .textBeforeImage
        } else if string == "text-after-image" {
            return .textAfterImage
        } else if string == "text-between-images" {
            return .textBetweenImages
        } else {
            throw RuntimeError("Unsupported layout type: \(string)")
        }
    }
    
    private static func transformColor(_ string: String) throws -> CGColor {
        let rgb = try parseRGB(string)
        let r = CGFloat(rgb.r) / 255
        let g = CGFloat(rgb.g) / 255
        let b = CGFloat(rgb.b) / 255
        return CGColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    private static func parseRGB(_ string: String) throws -> (r: Int, g: Int, b: Int) {
        let regex = try NSRegularExpression(pattern: "\\#([A-Fa-f0-9]{2})([A-Fa-f0-9]{2})([A-Fa-f0-9]{2})")
        let match = regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count))
        guard let match else {
            throw RuntimeError("Unsupported RGB hex string format. Required: #??????")
        }
        let nsString = string as NSString
        let hexR = nsString.substring(with: match.range(at: 1))
        let hexG = nsString.substring(with: match.range(at: 2))
        let hexB = nsString.substring(with: match.range(at: 3))
        let r = Int(hexR, radix: 16)!
        let g = Int(hexG, radix: 16)!
        let b = Int(hexB, radix: 16)!
        return (r, g, b)
    }
}
