//
//  Data+JSONTransformable.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 09/02/2018.
//

import Foundation

internal extension Data {
    internal func transformed<T: Codable>(for type: T.Type) -> Data {
        if type == (LiveContainer.self) {
            return transformed(using: LiveContainer.jsonTransformations)
        }
        
        return self
    }
    
    private func transformed(using transformations: [JSONTransformation]) -> Data {
        guard let jsonString = String(bytes: self, encoding: .utf8) else { return self }
        
        var json = jsonString
        
        for transformation in transformations {
            json = json.replacingOccurrences(of: transformation.from, with: transformation.to)
        }
        
        return json.data(using: .utf8) ?? self
    }
}
