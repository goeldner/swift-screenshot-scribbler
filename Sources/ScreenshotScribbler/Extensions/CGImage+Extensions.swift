//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

public extension CGImage {
    
    /// Creates a CoreGraphics `CGContext` with same size as this `CGImage`.
    ///
    /// - Returns: The `CGContext` instance.
    /// - Throws: `RuntimeError` if context cannot be created for any reason.
    ///
    func createCGContext() throws -> CGContext {
        let image = self
        let colorSpace = image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!
        guard let context = CGContext(data: nil, width: image.width, height: image.height, bitsPerComponent: image.bitsPerComponent, bytesPerRow: image.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else {
            throw RuntimeError("Error initializing CGContext")
        }
        return context
    }

    /// Creates encoded data of this image.
    ///
    /// - Parameter encoding: The encoding, e.g. `png` or `jpeg`.
    /// - Returns: The encoded data.
    /// - Throws: `RuntimeError` if image cannot be encoded for any reason.
    ///
    func encode(encoding: UTType) throws -> Data {
        let image = self
        guard let unlimitedMutableData = CFDataCreateMutable(nil, 0) else {
            throw RuntimeError("Error: CFDataCreateMutable")
        }
        let outputType = encoding.identifier as CFString
        guard let outputImageDestination = CGImageDestinationCreateWithData(unlimitedMutableData, outputType, 1, nil) else {
            throw RuntimeError("Error: CGImageDestinationCreateWithData")
        }
        CGImageDestinationAddImage(outputImageDestination, image, nil)
        guard CGImageDestinationFinalize(outputImageDestination) else {
            throw RuntimeError("Error: CGImageDestinationFinalize")
        }
        let outputImageData = unlimitedMutableData as Data
        return outputImageData
    }
    
}
