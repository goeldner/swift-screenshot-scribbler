//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
import ScreenshotScribbler

///
/// Command line options related to the background.
///
struct BackgroundOptions: ParsableArguments {
        
    @Option(name: .long, help: "Color which covers the whole background. (Default: \"#FFFFFF\" (white); Supports gradients)")
    var backgroundColor: ColorType?
    
    @Option(name: .customLong("background-image"), help: "The background image file to read. (Optional)")
    var backgroundImageFile: String?
    
    @Option(name: .long, help: "Scaling mode or factor (as decimal number) of the background image. (\(ImageScalingMode.defaultAndOptionsDescription(.stretchFill)))")
    var backgroundImageScaling: ImageScaling?
    
    @Option(name: .long, help: "Horizontal and/or vertical alignment of the background image, separated by space character. (Default: \"center middle\"; Options horizontal: \(HorizontalAlignment.allValueStrings); Options vertical: \(VerticalAlignment.allValueStrings))")
    var backgroundImageAlignment: Alignment?

}

///
/// Extension of the `BackgroundConfig` with functionality related to `BackgroundOptions`.
///
extension BackgroundConfig {
    
    /// Overwrites some attributes of this pre-filled `BackgroundConfig` with the option values that are defined
    /// in the given `BackgroundOptions` instance, i.e. those where the options are not `nil`.
    ///
    /// - Parameter options: The `BackgroundOptions` to apply.
    ///
    mutating func applyOptions(_ options: BackgroundOptions) {
        if let backgroundColor = options.backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let backgroundImageScaling = options.backgroundImageScaling {
            self.backgroundImageScaling = backgroundImageScaling
        }
        if let backgroundImageAlignment = options.backgroundImageAlignment {
            self.backgroundImageAlignment = backgroundImageAlignment
        }
    }
}
