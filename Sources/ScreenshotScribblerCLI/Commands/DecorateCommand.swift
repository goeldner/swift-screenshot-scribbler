//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
import CoreGraphics
import ScreenshotScribbler

///
/// Command line sub-command: `decorate`
///
struct DecorateCommand: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "decorate",
        abstract: "Decorates a screenshot with a nice background and caption."
    )

    @OptionGroup(title: "Output")
    var outputOptions: OutputOptions
    
    @OptionGroup(title: "Layout")
    var layoutOptions: LayoutOptions
    
    @OptionGroup(title: "Screenshot")
    var screenshotOptions: ScreenshotOptions
    
    @OptionGroup(title: "Caption")
    var captionOptions: CaptionOptions

    @OptionGroup(title: "Background")
    var backgroundOptions: BackgroundOptions
    
    @Flag(name: .long, help: "Show detailed progress updates.")
    var verbose = false

    struct OutputOptions: ParsableArguments {
        
        @Option(name: .customLong("output"), help: "The image file to write as output. (Required)")
        var outputFile: String
        
    }
    
    func run() throws {
        do {
            printVerbose("Starting...")
            
            // Read data of screenshot file
            print("Screenshot: \(self.screenshotOptions.screenshotFile)")
            let screenshotData = try Data(fromFilePath: self.screenshotOptions.screenshotFile)
            
            // Optionally read data of background image file
            let backgroundImageData: Data?
            if let backgroundImage = self.backgroundOptions.backgroundImageFile {
                print("Background: \(backgroundImage)")
                backgroundImageData = try Data(fromFilePath: backgroundImage)
            } else {
                backgroundImageData = nil
            }
            
            // Parse the configuration options
            printVerbose("Preparing configuration...")
            let config = createConfigFromOptions()
            
            // Generate the new image
            printVerbose("Generating output image...")
            let caption = self.captionOptions.caption
            let scrscr = ScreenshotScribbler(screenshot: screenshotData,
                                             backgroundImage: backgroundImageData,
                                             caption: caption,
                                             config: config)
            let output = try scrscr.decorate()
            
            // Write data to output file
            print("Output: \(self.outputOptions.outputFile)")
            try output.writeToFilePath(self.outputOptions.outputFile)
            
            printVerbose("Finished successful.")
        } catch {
            printVerbose("Finished with error: \(error)")
            throw error
        }
    }
    
    /// Prints the message if verbose mode is active.
    ///
    /// - Parameter message: The message.
    ///
    private func printVerbose(_ message: String) {
        if verbose {
            print(message)
        }
    }
    
    /// Creates a default `DecorateActionConfig` instance and overwrites all values
    /// with those that were defined on command line.
    ///
    /// - Returns: The `DecorateActionConfig` adapted to command line options.
    ///
    private func createConfigFromOptions() -> DecorateActionConfig {
        var config = DecorateActionConfig()
        config.layout.applyOptions(self.layoutOptions)
        config.screenshot.applyOptions(self.screenshotOptions)
        config.caption.applyOptions(self.captionOptions)
        config.background.applyOptions(self.backgroundOptions)
        return config
    }

}
