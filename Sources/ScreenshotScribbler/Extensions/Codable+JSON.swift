//
// Copyright © 2023 Christoph Göldner. All rights reserved.
//

import Foundation

public extension Encodable {
    
    /// Encodes this instance to pretty printed JSON data.
    ///
    /// - Returns: The JSON data.
    ///
    func toJSON() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        let json = try encoder.encode(self)
        return json
    }
}

public extension Decodable {
    
    /// Creates this instance by decoding the given JSON data.
    ///
    /// - Parameter json: The JSON data.
    /// 
    init(fromJSON json: Data) throws {
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: json)
    }
}

public extension KeyedDecodingContainer {
    
    /// Decodes a value of the given type for the given key without failing if the key is not present.
    /// If the value can be decoded, then the given setter function is invoked.
    ///
    /// This is useful, when the decodable data structure defines defaults for all its values. So it is
    /// not necessary to set them all on initialization. For example, the structure could be created by
    /// decoding a partial JSON document, which only contains those values that shall be overridden.
    ///
    /// - Parameters:
    ///   - type: The type of value to decode.
    ///   - key: The key that the decoded value is associated with.
    ///   - set: The setter to invoke on success.
    ///
    func decodeAndSetIfPresent<T>(_ type: T.Type, _ key: KeyedDecodingContainer<K>.Key, set: (T) -> Void) throws where T : Decodable {
        do {
            let T = try self.decode(type, forKey: key)
            set(T)
        } catch DecodingError.keyNotFound {
            // key not present => ignore
        }
    }
}
