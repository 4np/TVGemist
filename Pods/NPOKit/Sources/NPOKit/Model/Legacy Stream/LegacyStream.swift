//
//  LegacyStream.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 07/12/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public struct LegacyStream: Codable {
    public private(set) var limited = false
    public private(set) var items = [[LegacyStreamItem]]()
    
    enum CodingKeys: String, CodingKey {
        case limited
        case items
    }
    
    public var url: URL? {
        return bestStreamItem()?.url
    }
    
    internal func bestStreamItem() -> LegacyStreamItem? {
        let flatItems = items.flatMap({ $0 })
        
        if let item = flatItems.first(where: { $0.type == .adaptive }) {
            return item
        } else if let item = flatItems.first(where: { $0.type == .high }) {
            return item
        } else if let item = flatItems.first(where: { $0.type == .normal }) {
            return item
        } else if let item = flatItems.first(where: { $0.type == .low }) {
            return item
        } else if let item = flatItems.first(where: { $0.type == .live }) {
            return item
        }
        
        return nil
    }
}
