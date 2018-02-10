//
//  LegacyStreamItem.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 07/12/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public enum LegacyStreamItemType: String, Codable {
    case adaptive = "Adaptive"
    case high = "Hoog"
    case normal = "Normaal"
    case low = "Laag"
    case live = "Live"
}

public enum LegacyStreamItemFormat: String, Codable {
    case hls
    case mpeg = "mp4"
}

public struct LegacyStreamItem: Codable {
    internal private(set) var type: LegacyStreamItemType
    internal private(set) var contentType: String
    private var rawURL: URL
    internal private(set) var format: LegacyStreamItemFormat
    
    internal var url: URL? {
        var components = URLComponents(url: rawURL, resolvingAgainstBaseURL: false)
        
        // remove JSONP query items
        let queryItems = components?.queryItems?.filter { !["type", "callback", "protection"].contains($0.name) }
        components?.queryItems = queryItems

        return components?.url
    }
    
    enum CodingKeys: String, CodingKey {
        case type = "label"
        case contentType
        case rawURL = "url"
        case format
    }
}
