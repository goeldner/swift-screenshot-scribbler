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

}

///
/// Extension of the `CaptionConfig` with functionality related to `CaptionOptions`.
///
extension CaptionConfig {
    
    /// Overwrites some attributes of this pre-filled `CaptionConfig` with the option values that are defined
    /// in the given `CaptionOptions` instance, i.e. those where the options are not `nil`.
    ///
    /// - Parameter options: The `CaptionOptions` to apply.
    ///
    mutating func applyOptions(_ options: CaptionOptions) {
        if let captionSizeFactor = options.captionSizeFactor {
            self.captionSizeFactor = captionSizeFactor
        }
        if let captionAlignment = options.captionAlignment {
            self.captionAlignment = captionAlignment
        }
        if let captionColor = options.captionColor {
            self.captionColor = captionColor
        }
        if let captionFontName = options.captionFontName {
            self.captionFontName = captionFontName
        }
        if let captionFontStyle = options.captionFontStyle {
            self.captionFontStyle = captionFontStyle
        }
        if let captionFontSize = options.captionFontSize {
            self.captionFontSize = captionFontSize
        }
    }
}
