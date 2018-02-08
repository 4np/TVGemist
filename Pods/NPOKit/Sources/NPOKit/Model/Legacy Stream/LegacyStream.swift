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
    
    internal func hlsItem() -> LegacyStreamItem? {
        for item in items {
            if let hlsItem = item.first(where: { $0.format == "hls" }) {
                return hlsItem
            }
        }
        
        return nil
    }
}
