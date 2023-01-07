//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation

/// Image scaling options.
public enum ImageScaling: String, CaseIterable {
    
    /// Do not apply any scaling to the image.
    /// If the image is smaller than the available space, then the space may not be completely filled, but the whole image will be visible inside the space.
    /// If the image is larger than the available space, then the image may exceed the space, so parts of the image could become invisible when clipped to the space.
    case none = "none"
    
    /// Stretch the image to fill the whole available space, without respecting the image proportions.
    case stretchFill = "stretch-fill"
    
    /// Resize the image to fill the available space completely, keeping the original aspect ratio.
    /// The whole space will be covered and the image may exceed the space, so parts of the image could become invisible when clipped to the space.
    case aspectFill = "aspect-fill"
    
    /// Resize the image to fit completely into the available space, keeping the original aspect ratio.
    /// The space may not be completely filled, but the whole image will be visible inside the space.
    case aspectFit = "aspect-fit"

}
