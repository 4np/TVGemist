//
//  Token.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 07/12/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

internal struct Token: Codable {
    private static let lifetime = 3600 // token lifetime in seconds (1h)
    internal let date = Date()
    public private(set) var value: String
    
    enum CodingKeys: String, CodingKey {
        case value = "token"
    }
    
    internal var age: Double {
        return Date().timeIntervalSince(date)
    }
    
    private var expiryDate: Date? {
        return Date(timeInterval: Double(Token.lifetime), since: date)
    }
    
    internal var hasExpired: Bool {
        guard let expiryDate = self.expiryDate else {
            return true
        }
        
        let now = Date()
        let comparison = expiryDate.compare(now)
        return (comparison == .orderedAscending || comparison == .orderedSame)
    }
}
