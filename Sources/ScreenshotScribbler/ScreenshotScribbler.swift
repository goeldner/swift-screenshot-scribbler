//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation

public struct ScreenshotScribbler {

    private let caption: String
    private let input: Data

    /// Initializes the screenshot scribbler with an input image and caption.
    ///
    /// - Parameter input: The input image in PNG data format.
    /// - Parameter caption: The caption to add to the screenshot.
    ///
    public init(input: Data, caption: String) {
        self.input = input
        self.caption = caption
    }

    /// Generates the output image based on the configured input image, caption and layout settings.
    ///
    /// - Returns: The output image as PNG data.
    ///
    public func generate() throws -> Data {
        return self.input
    }
}
