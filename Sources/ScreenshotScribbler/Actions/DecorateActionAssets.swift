//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation

///
/// Media and text resource assets that are utilized by the `decorate` action.
///
/// Note: All assets are optional and loaded on demand. Some assets may be required
/// depending on the configured appearance and are checked for existance during runtime.
///
public struct DecorateActionAssets {
    
    /// Screenshot image data.
    public var screenshot: Data?
    
    /// Background image data.
    public var background: Data?
    
    /// Caption text.
    public var caption: String?
    
    /// Public initializer.
    public init() {}

}
