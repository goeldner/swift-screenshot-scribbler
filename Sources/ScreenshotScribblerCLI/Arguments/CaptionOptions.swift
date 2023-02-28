//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
import ScreenshotScribbler

///
/// Command line options related to the caption.
///
struct CaptionOptions: ParsableArguments {
    
    @Option(name: .long, help: "The caption to scribble. (Optional)")
    var caption: String?
    
    @Option(name: .long, help: "Percentage of the caption area height relative to the total height of the output image. (Default: 0.25 (25%))")
    var captionSizeFactor: Double?
    
    @Option(name: .long, help: "Horizontal alignment of the caption. (\(HorizontalTextAlignment.defaultAndOptionsDescription(.center)))")
    var captionAlignment: HorizontalTextAlignment?
    
    @Option(name: .long, help: "Color of the caption. (Default: \"#000000\" (black); Supports gradients)")
    var captionColor: ColorType?
    
    @Option(name: .long, help: "Font family name of the caption. (Default: \"SF Compact\")")
    var captionFontName: String?
    
    @Option(name: .long, help: "Font style of the caption. (Default: \"Bold\")")
    var captionFontStyle: String?
    
    @Option(name: .long, help: "Font size of the caption. (Default: 32)")
    var captionFontSize: Int?

    /// Creates a new `LayoutConfig` based on the given pre-filled `LayoutConfig` and
    /// overwrites some attributes with the option values that are defined here, i.e. that are not `nil`.
    ///
    /// - Parameter layoutConfig: The current `LayoutConfig`.
    /// - Returns: The modified `LayoutConfig`.
    ///
    func applyToLayoutConfig(_ layoutConfig: LayoutConfig) -> LayoutConfig {
        var layout = layoutConfig
        if let captionSizeFactor {
            layout.captionSizeFactor = captionSizeFactor
        }
        if let captionAlignment {
            layout.captionAlignment = captionAlignment
        }
        if let captionColor {
            layout.captionColor = captionColor
        }
        if let captionFontName {
            layout.captionFontName = captionFontName
        }
        if let captionFontStyle {
            layout.captionFontStyle = captionFontStyle
        }
        if let captionFontSize {
            layout.captionFontSize = captionFontSize
        }
        return layout
    }
    
}
