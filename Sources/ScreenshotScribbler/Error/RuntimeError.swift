//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation

///
/// Error type that is thrown for all error cases that occur during runtime.
///
public struct RuntimeError: Error, CustomStringConvertible {
    
    /// The description of the error case.
    public var description: String
    
    /// Creates the error including a description.
    public init(_ description: String) {
        self.description = description
    }
}
