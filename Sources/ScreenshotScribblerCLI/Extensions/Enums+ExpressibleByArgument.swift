//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import ArgumentParser
import ScreenshotScribbler

extension HorizontalAlignment: ExpressibleByArgument, HasDefaultAndOptions {
}

extension HorizontalTextAlignment: ExpressibleByArgument, HasDefaultAndOptions {
}

extension ImageScaling: ExpressibleByArgument, HasDefaultAndOptions {
}

extension LayoutType: ExpressibleByArgument, HasDefaultAndOptions {
}

extension VerticalAlignment: ExpressibleByArgument, HasDefaultAndOptions {
}

/// Marker protocol for enums that semantically have a default value and a list of pre-defined options.
protocol HasDefaultAndOptions {
}

extension ExpressibleByArgument where Self: HasDefaultAndOptions {
    
    /// Generates a string describing the default value and all possible options of this argument type in format:
    /// `Default: "<default-value>"; Options: ["<option-1>", ..., "<option-n>"]`
    ///
    /// - Parameter defaultValue: The default value.
    /// - Returns: The description.
    ///
    static func defaultAndOptionsDescription(_ defaultValue: Self) -> String {
        return "Default: \"\(defaultValue.defaultValueDescription)\"; Options: \(Self.allValueStrings)"
    }
}
