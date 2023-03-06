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

}

///
/// Extension of the `LayoutConfig` with functionality related to `LayoutOptions`.
///
extension LayoutConfig {
    
    /// Overwrites some attributes of this pre-filled `LayoutConfig` with the option values that are defined
    /// in the given `LayoutOptions` instance, i.e. those where the options are not `nil`.
    ///
    /// - Parameter options: The `LayoutOptions` to apply.
    ///
    mutating func applyOptions(_ options: LayoutOptions) {
        if let layoutType = options.layoutType {
            self.layoutType = layoutType
        }
    }
}
