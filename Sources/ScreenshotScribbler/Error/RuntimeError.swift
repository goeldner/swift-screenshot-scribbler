//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation

public struct RuntimeError: Error, CustomStringConvertible {
    
    public var description: String
    
    public init(_ description: String) {
        self.description = description
    }
}
