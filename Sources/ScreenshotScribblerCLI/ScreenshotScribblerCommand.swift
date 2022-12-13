//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
import CoreGraphics
import ScreenshotScribbler

@main
struct ScreenshotScribblerCommand: ParsableCommand {

    static let configuration = CommandConfiguration(commandName: "scrscr", abstract: "Creates a new image with same dimensions as a given screenshot, adds a background, reduces the size of the original screenshot, places it nicely and scribbles a caption besides it.")

    @Option(name: .shortAndLong, help: "The caption to scribble.")
    var caption: String

    @Option(name: [.short, .customLong("input")], help: "The screenshot file to read.")
    var inputFile: String

    @Option(name: [.short, .customLong("output")], help: "The output image to write.")
    var outputFile: String

    @Option(name: .long, help: "Arrangement of the caption and the screenshot. (\"text-before-image\" by default)", transform: transformLayoutType)
    var layoutType: LayoutType?
    
    @Option(name: .long, help: "Amount of the text area in vertical direction. (25% by default)")
    var textAreaRatio: Double?
    
    @Option(name: .long, help: "Percentage of the screenshot in reduced size. (85% by default)")
    var imageSizeReduction: Double?
    
    @Option(name: .long, help: "Color which covers the whole background. (white by default)", transform: transformColor)
    var backgroundColor: CGColor?
    
    @Option(name: .long, help: "Color of the rendered caption. (black by default)", transform: transformColor)
    var textColor: CGColor?
    
    @Option(name: .long, help: "Font family name. (\"SF Compact\" by default)")
    var fontName: String?
    
    @Option(name: .long, help: "Font style. (\"Bold\" by default)")
    var fontStyle: String?
    
    @Option(name: .long, help: "Font size. (32 by default)")
    var fontSize: Int?
    
    @Option(name: .long, help: "Size of the shadow blur. (5 by default)")
    var shadowSize: Double?
    
    @Option(name: .long, help: "Color of the shadow. (black by default)", transform: transformColor)
    var shadowColor: CGColor?
    
    @Flag(name: .shortAndLong, help: "Print details and progress updates.")
    var verbose = false

    func run() throws {

        // Read data of input file
        print("input: \(inputFile)")
        let inputUrl = URL(fileURLWithPath: inputFile)
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
        let scribbler = ScreenshotScribbler(input: inputData, caption: caption, layout: layoutConfig)
        let output = try scribbler.generate()

        // Write data to output file
        print("output: \(outputFile)")
        let outputUrl = URL(fileURLWithPath: outputFile)
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
        if let layoutType {
            layout.layoutType = layoutType
        }
        if let textAreaRatio {
            layout.textAreaRatio = textAreaRatio
        }
        if let imageSizeReduction {
            layout.imageSizeReduction = imageSizeReduction
        }
        if let backgroundColor {
            layout.backgroundColor = backgroundColor
        }
        if let textColor {
            layout.textColor = textColor
        }
        if let fontName {
            layout.fontName = fontName
        }
        if let fontStyle {
            layout.fontStyle = fontStyle
        }
        if let fontSize {
            layout.fontSize = fontSize
        }
        if let shadowSize {
            layout.shadowSize = shadowSize
        }
        if let shadowColor {
            layout.shadowColor = shadowColor
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
