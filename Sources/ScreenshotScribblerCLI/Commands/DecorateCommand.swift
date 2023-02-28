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

    @OptionGroup(title: "Basic")
    var basicOptions: BasicOptions
    
    @OptionGroup(title: "Screenshot")
    var screenshotOptions: ScreenshotOptions
    
    @OptionGroup(title: "Caption")
    var captionOptions: CaptionOptions

    @OptionGroup(title: "Background")
    var backgroundOptions: BackgroundOptions
    
    @Flag(name: .long, help: "Show detailed progress updates.")
    var verbose = false

    struct BasicOptions: ParsableArguments {
        
        @Option(name: .customLong("output"), help: "The output image file to write. (Required)")
        var outputFile: String
        
        @Option(name: .customLong("layout"), help: "Arrangement of the caption and screenshot. (\(LayoutType.defaultAndOptionsDescription(.captionBeforeScreenshot)))")
        var layoutType: LayoutType?
        
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
            
            // Parse the layout configuration options
            printVerbose("Preparing layout configuration...")
            let layoutConfig = createLayoutConfigFromOptions()
            
            // Generate the new image
            printVerbose("Generating output image...")
            let caption = self.captionOptions.caption
            let scrscr = ScreenshotScribbler(screenshot: screenshotData,
                                             backgroundImage: backgroundImageData,
                                             caption: caption,
                                             layout: layoutConfig)
            let output = try scrscr.generate()
            
            // Write data to output file
            print("Output: \(self.basicOptions.outputFile)")
            try output.writeToFilePath(self.basicOptions.outputFile)
            
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
    
    /// Creates a default `LayoutConfig` instance and overwrites all values with those
    /// that were defined on command line.
    ///
    /// - Returns: The `LayoutConfig` adapted to command line options.
    ///
    private func createLayoutConfigFromOptions() -> LayoutConfig {
        var layout = LayoutConfig()
        if let layoutType = self.basicOptions.layoutType {
            layout.layoutType = layoutType
        }
        layout = self.screenshotOptions.applyToLayoutConfig(layout)
        layout = self.captionOptions.applyToLayoutConfig(layout)
        layout = self.backgroundOptions.applyToLayoutConfig(layout)
        return layout
    }

}
