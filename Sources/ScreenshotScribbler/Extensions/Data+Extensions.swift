//
// Copyright © 2022 Christoph Göldner. All rights reserved.
//

import Foundation
import CoreGraphics
import UniformTypeIdentifiers

public extension Data {
    
    /// Creates a CoreGraphics `CGImage` based on the encoded PNG or JPEG data.
    /// If no encoding is provided, it tries to resolve the type by examining the first bytes of this data instance.
    ///
    /// - Parameter encoding: The encoding of the data bytes. Only `png` and `jpeg` supported. May be `nil`.
    /// - Returns: The `CGImage` instance.
    /// - Throws: `RuntimeError` if image cannot be created for any reason.
    ///
    func createCGImage(encoding: UTType? = nil) throws -> CGImage {
        let data = self
        let imageType = encoding ?? resolveImageType()
        guard let dataProvider = CGDataProvider(data: data as CFData) else {
            throw RuntimeError("Error initializing CGDataProvider")
        }
        let image: CGImage?
        switch imageType {
        case .png:
            image = CGImage(pngDataProviderSource: dataProvider, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
        case .jpeg:
            image = CGImage(jpegDataProviderSource: dataProvider, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
        default:
            throw RuntimeError("Unsupported image encoding: \(imageType)")
        }
        guard let image else {
            throw RuntimeError("Error initializing CGImage")
        }
        return image
    }
    
    /// Tries to resolve the image type based on the first bytes of this data instance.
    /// Currently only `png` or `jpeg` is detected. In any other case `data` is returned.
    ///
    /// - Returns: The image type or `data`.
    ///
    private func resolveImageType() -> UTType {
        let signatureJPEG:[UInt8] = [0xff, 0xd8, 0xff]
        let signaturePNG:[UInt8] = [0x89, 0x50, 0x4e, 0x47]
        if firstBytes(4) == signaturePNG {
            return .png
        } else if firstBytes(3) == signatureJPEG {
            return .jpeg
        } else {
            return .data
        }
    }
    
    /// Returns the first bytes of this data instance up to the specified length.
    ///
    /// - Parameter length: The number of bytes to return.
    /// - Returns: The bytes up to the specified length.
    ///
    private func firstBytes(_ length: Int) -> [UInt8] {
        let data = self
        let subdata = data.subdata(in: 0 ..< length)
        let bytes = [UInt8](subdata)
        return bytes
    }

}
