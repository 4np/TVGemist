//
//  LegacyStreamItem.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 07/12/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public struct LegacyStreamItem: Codable {
    internal private(set) var label: String
    internal private(set) var contentType: String
    private var rawURL: URL
    internal private(set) var format: String
    
    internal var url: URL? {
        var components = URLComponents(url: rawURL, resolvingAgainstBaseURL: false)
        
        // remove JSONP query items
        let queryItems = components?.queryItems?.filter { !["type", "callback"].contains($0.name) }
        components?.queryItems = queryItems
        
        return components?.url
    }
    
    enum CodingKeys: String, CodingKey {
        case label
        case contentType
        case rawURL = "url"
        case format
    }
}
