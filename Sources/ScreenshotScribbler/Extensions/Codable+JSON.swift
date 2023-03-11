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
        encoder.outputFormatting = .prettyPrinted
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
