//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation

///
/// This class provides access to all available screenshot scribbler actions
/// and can be used to invoke them conveniently.
/// 
public struct ScreenshotScribbler {

    /// Public initializer.
    public init() {}

    /// Decorates a screenshot with a background and caption and returns the result as PNG image.
    /// The appearance can be controlled by the settings of the given configuration instance.
    ///
    /// - Parameters:
    ///   - assets: The media and text assets that are used by the `decorate` action. (Required)
    ///   - config: The configured appearance settings of the `decorate` action. (Optional)
    /// - Returns: The output image as PNG data.
    ///
    public func decorate(assets: DecorateActionAssets, config: DecorateActionConfig = DecorateActionConfig()) throws -> Data {
        let action = DecorateAction(assets: assets, config: config)
        return try action.run()
    }

}
