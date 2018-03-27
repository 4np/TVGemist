//
//  LiveComponent.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 09/02/2018.
//

import Foundation

enum LiveComponentType: String, Codable {
    case nowPlaying = "nowplaying"
    case liveHeader = "liveheader"
    case picker = "picker"
    case grid = "grid"
}

public struct LiveComponent: Codable {
    var id: String
    var type: LiveComponentType
    var subType: String
    var isPlaceholder: Bool
    
    var epgSingular: LiveBroadcast?
    var epgPlural: [LiveBroadcast]?

    public var broadcasts: [LiveBroadcast]? {
        if let epg = epgSingular {
            return [epg]
        } else if let epg = epgPlural {
            return epg
        }
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case subType
        case isPlaceholder
        
        case epgSingular = "epg_singular"
        case epgPlural = "epg_plural"
    }
}
