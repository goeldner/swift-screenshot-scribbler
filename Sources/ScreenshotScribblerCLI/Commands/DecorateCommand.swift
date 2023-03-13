//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
import ScreenshotScribbler

///
/// Command line sub-command: `decorate`
///
struct DecorateCommand: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "decorate",
        abstract: "Decorates a screenshot with a nice background and caption."
    )

    @OptionGroup(title: "Files")
    var fileOptions: FileOptions
    
    @OptionGroup(title: "Layout")
    var layoutOptions: LayoutOptions
    
    @OptionGroup(title: "Screenshot")
    var screenshotOptions: ScreenshotOptions
    
    @OptionGroup(title: "Background")
    var backgroundOptions: BackgroundOptions
    
    @OptionGroup(title: "Caption")
    var captionOptions: CaptionOptions

    @Flag(name: .long, help: "Show detailed progress updates.")
    var verbose = false

    struct FileOptions: ParsableArguments {
        
        @Option(name: .customLong("output"), help: "The image file to write as output. (Required)")
        var outputFile: String
        
        @Option(name: .customLong("config"), help: "Provide a JSON file that contains all the options that could be defined on command line. This file is read first. Command line options override the settings of the file. (Optional)")
        var configFile: String?
        
    }
    
    func run() throws {
        do {
            printVerbose("Starting...")
            
            // Load the assets
            printVerbose("Loading assets from options...")
            let assets = try loadAssetsFromOptions()
            
            // Parse the configuration options
            printVerbose("Preparing configuration from options...")
            let config = try createConfigFromOptions()
            
            // Generate the new image
            printVerbose("Generating output image...")
            let scrscr = ScreenshotScribbler()
            let output = try scrscr.decorate(assets: assets, config: config)
            
            // Write data to output file
            print("Output: \(self.fileOptions.outputFile)")
            try output.writeToFilePath(self.fileOptions.outputFile)
            
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
    
    /// Creates a `DecorateActionAssets` instance and loads all available
    /// assets that are defined as command line options.
    ///
    /// - Returns: The `DecorateActionAssets` with loaded assets, if defined as command line options.
    ///
    private func loadAssetsFromOptions() throws -> DecorateActionAssets {
        
        // Read data of screenshot file if defined
        let screenshotImageData: Data?
        if let screenshotImageFile = self.screenshotOptions.screenshotImageFile {
            print("Screenshot: \(screenshotImageFile)")
            screenshotImageData = try Data(fromFilePath: screenshotImageFile)
        } else {
            screenshotImageData = nil
        }
        
        // Read data of background image file if defined
        let backgroundImageData: Data?
        if let backgroundImageFile = self.backgroundOptions.backgroundImageFile {
            print("Background: \(backgroundImageFile)")
            backgroundImageData = try Data(fromFilePath: backgroundImageFile)
        } else {
            backgroundImageData = nil
        }
        
        var assets = DecorateActionAssets()
        assets.screenshot = screenshotImageData
        assets.background = backgroundImageData
        assets.caption = self.captionOptions.caption
        return assets
    }

    /// Creates a default `DecorateActionConfig` instance and overwrites all values
    /// with those that were defined as command line options.
    ///
    /// - Returns: The `DecorateActionConfig` adapted to command line options.
    ///
    private func createConfigFromOptions() throws -> DecorateActionConfig {
        var config: DecorateActionConfig

        if let configFile = self.fileOptions.configFile {
            // load the options from JSON first if defined
            print("Config: \(configFile)")
            let configFileData = try Data(fromFilePath: configFile)
            config = try DecorateActionConfig(fromJSON: configFileData)
        } else {
            // otherwise use defaults
            config = DecorateActionConfig()
        }

        // override with options from command line
        config.layout.applyOptions(self.layoutOptions)
        config.screenshot.applyOptions(self.screenshotOptions)
        config.background.applyOptions(self.backgroundOptions)
        config.caption.applyOptions(self.captionOptions)
        
        return config
    }

}
