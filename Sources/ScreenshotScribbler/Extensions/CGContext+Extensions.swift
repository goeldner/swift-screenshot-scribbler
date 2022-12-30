//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGContext {
    
    /// Creates a CoreGraphics `CGImage` of this graphics context.
    ///
    /// - Returns: The `CGImage` instance.
    /// - Throws: `RuntimeError` if image cannot be created for any reason. 
    ///
    func createCGImage() throws -> CGImage {
        let context = self
        guard let outputImage = context.makeImage() else {
            throw RuntimeError("Error creating CGImage from CGContext")
        }
        return outputImage
    }
}
