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
    
    @Option(name: .customLong("background-image"), help: "The background image file to read. (Default: none)")
    var backgroundImageFile: String?
    
    @Option(name: .long, help: "Scaling mode or factor (as decimal number) of the background image. (\(ImageScalingMode.defaultAndOptionsDescription(.stretchFill)))")
    var backgroundImageScaling: ImageScaling?
    
    @Option(name: .long, help: "Horizontal and/or vertical alignment of the background image, separated by space character. (Default: \"center middle\"; Options horizontal: \(HorizontalAlignment.allValueStrings); Options vertical: \(VerticalAlignment.allValueStrings))")
    var backgroundImageAlignment: Alignment?

    /// Creates a new `LayoutConfig` based on the given pre-filled `LayoutConfig` and
    /// overwrites some attributes with the option values that are defined here, i.e. that are not `nil`.
    ///
    /// - Parameter layoutConfig: The current `LayoutConfig`.
    /// - Returns: The modified `LayoutConfig`.
    ///
    func applyToLayoutConfig(_ layoutConfig: LayoutConfig) -> LayoutConfig {
        var layout = layoutConfig
        if let backgroundColor {
            layout.backgroundColor = backgroundColor
        }
        if let backgroundImageScaling {
            layout.backgroundImageScaling = backgroundImageScaling
        }
        if let backgroundImageAlignment {
            layout.backgroundImageAlignment = backgroundImageAlignment
        }
        return layout
    }

}
