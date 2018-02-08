//
//  Component.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 27/10/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

/// There is also a component 'subType' but that always
/// seems to be 'default' (at least for now) and default
/// does not work well inside enums...
enum ComponentType: String, Codable {
    case unknown
    
    // Catalogue component types
    case filter
    case grid
    case loadmore
    
    // Home component types
    case spotlightheader
    case continuewatching
    case subscription
    case lane
}

struct Component: Codable {
    var id: String
    var title: String?
    private var typeName: String
    private var subTypeName: String
    var isPlaceholder: Bool = false
    var filters: [Filter]?
    var data: ComponentData?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title
        case typeName = "type"
        case subTypeName = "subType"
        case isPlaceholder
        case filters
        case data
    }
}

// MARK: Calculated properties
extension Component {
    
    // MARK: Enums
    
    var type: ComponentType? {
        return ComponentType(rawValue: typeName)
    }
}

struct ComponentData: Codable {
    var total: Int
    var count: Int
    var items: [Item]
}
