//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation

/// Image scaling options.
public enum ImageScaling {
    
    /// Scale the image according to one of the pre-defined modes.
    case mode(_ mode: ImageScalingMode)
    
    /// Scale the image according to a custom factor.
    case factor(_ factor: Double)
    
}
