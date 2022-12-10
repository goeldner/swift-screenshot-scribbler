//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
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
        
        // Generate the new image
        if verbose {
            print("generating image...")
        }
        let scribbler = ScreenshotScribbler(input: inputData, caption: caption)
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
}
