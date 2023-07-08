//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
import ScreenshotScribbler

///
/// Command line options related to the screenshot.
///
struct ScreenshotOptions: ParsableArguments {
    
    @Option(name: .customLong("screenshot"), help: "The screenshot image file to read. (Optional)")
    var screenshotImageFile: String?
    
    @Option(name: .long, help: "Percentage of the rendered screenshot size relative to its original size. (Default: 0.85 (85%))")
    var screenshotSizeFactor: Double?
    
    @Option(name: .long, help: "Corner radius of the screenshot. (Default: 5)")
    var screenshotCornerRadius: Double?
    
    @Option(name: .long, help: "Size of the shadow blur behind the screenshot. (Default: 5)")
    var screenshotShadowSize: Double?
    
    @Option(name: .long, help: "Color of the shadow behind the screenshot. (Default: \"#000000\" (black))")
    var screenshotShadowColor: Color?

    @Option(name: .long, help: "Size of the border around the screenshot. (Default: 0)")
    var screenshotBorderSize: Double?

    @Option(name: .long, help: "Color of the border around the screenshot. (Default: \"#000000\" (black); Supports gradients)")
    var screenshotBorderColor: ColorType?

    @Option(name: .long, parsing: .unconditional, help: "Rotation angle of the screenshot. (Default: \"0\"; Supports degrees e.g. \"45deg\" or radians e.g. \"-3.1415rad\")")
    var screenshotRotation: Angle?

}

///
/// Extension of the `ScreenshotConfig` with functionality related to `ScreenshotOptions`.
///
extension ScreenshotConfig {
    
    /// Overwrites some attributes of this pre-filled `ScreenshotConfig` with the option values that are defined
    /// in the given `ScreenshotOptions` instance, i.e. those where the options are not `nil`.
    ///
    /// - Parameter options: The `ScreenshotOptions` to apply.
    ///
    mutating func applyOptions(_ options: ScreenshotOptions) {
        if let screenshotSizeFactor = options.screenshotSizeFactor {
            self.screenshotSizeFactor = screenshotSizeFactor
        }
        if let screenshotCornerRadius = options.screenshotCornerRadius {
            self.screenshotCornerRadius = screenshotCornerRadius
        }
        if let screenshotShadowSize = options.screenshotShadowSize {
            self.screenshotShadowSize = screenshotShadowSize
        }
        if let screenshotShadowColor = options.screenshotShadowColor {
            self.screenshotShadowColor = screenshotShadowColor
        }
        if let screenshotBorderSize = options.screenshotBorderSize {
            self.screenshotBorderSize = screenshotBorderSize
        }
        if let screenshotBorderColor = options.screenshotBorderColor {
            self.screenshotBorderColor = screenshotBorderColor
        }
        if let screenshotRotation = options.screenshotRotation {
            self.screenshotRotation = screenshotRotation
        }
    }
}
