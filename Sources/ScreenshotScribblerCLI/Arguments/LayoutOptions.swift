//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
import ScreenshotScribbler

///
/// Command line options related to the layout.
///
struct LayoutOptions: ParsableArguments {
    
    @Option(name: .customLong("layout"), help: "Arrangement of the caption and screenshot. (\(LayoutType.defaultAndOptionsDescription(.captionBeforeScreenshot)))")
    var layoutType: LayoutType?

    /// Creates a new `LayoutConfig` based on the given pre-filled `LayoutConfig` and
    /// overwrites some attributes with the option values that are defined here, i.e. that are not `nil`.
    ///
    /// - Parameter layoutConfig: The current `LayoutConfig`.
    /// - Returns: The modified `LayoutConfig`.
    ///
    func applyToLayoutConfig(_ layoutConfig: LayoutConfig) -> LayoutConfig {
        var layout = layoutConfig
        if let layoutType {
            layout.layoutType = layoutType
        }
        return layout
    }
    
}
