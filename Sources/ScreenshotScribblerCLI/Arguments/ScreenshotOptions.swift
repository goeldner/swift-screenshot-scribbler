//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
import CoreGraphics
import ScreenshotScribbler

///
/// Command line options related to the screenshot.
///
struct ScreenshotOptions: ParsableArguments {
    
    @Option(name: .customLong("screenshot"), help: "The screenshot image file to read. (Required)")
    var screenshotFile: String
    
    @Option(name: .long, help: "Percentage of the rendered screenshot size relative to its original size. (Default: 0.85 (85%))")
    var screenshotSizeFactor: Double?
    
    @Option(name: .long, help: "Corner radius of the screenshot. (Default: 5)")
    var screenshotCornerRadius: Double?
    
    @Option(name: .long, help: "Size of the shadow blur behind the screenshot. (Default: 5)")
    var screenshotShadowSize: Double?
    
    @Option(name: .long, help: "Color of the shadow behind the screenshot. (Default: \"#000000\" (black))", transform: CGColor.initFromArgument)
    var screenshotShadowColor: CGColor?

    @Option(name: .long, help: "Size of the border around the screenshot. (Default: 0)")
    var screenshotBorderSize: Double?
    
    @Option(name: .long, help: "Color of the border around the screenshot. (Default: \"#000000\" (black); Supports gradients)")
    var screenshotBorderColor: ColorType?

    /// Creates a new `LayoutConfig` based on the given pre-filled `LayoutConfig` and
    /// overwrites some attributes with the option values that are defined here, i.e. that are not `nil`.
    ///
    /// - Parameter layoutConfig: The current `LayoutConfig`.
    /// - Returns: The modified `LayoutConfig`.
    ///
    func applyToLayoutConfig(_ layoutConfig: LayoutConfig) -> LayoutConfig {
        var layout = layoutConfig
        if let screenshotSizeFactor {
            layout.screenshotSizeFactor = screenshotSizeFactor
        }
        if let screenshotCornerRadius {
            layout.screenshotCornerRadius = screenshotCornerRadius
        }
        if let screenshotShadowSize {
            layout.screenshotShadowSize = screenshotShadowSize
        }
        if let screenshotShadowColor {
            layout.screenshotShadowColor = screenshotShadowColor
        }
        if let screenshotBorderSize {
            layout.screenshotBorderSize = screenshotBorderSize
        }
        if let screenshotBorderColor {
            layout.screenshotBorderColor = screenshotBorderColor
        }
        return layout
    }
    
}
