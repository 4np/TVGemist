//
//  FilterOption.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 18/12/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public struct FilterOption: Codable {
    public internal(set) var title: String
    internal var value: String?
    public internal(set) var isDefault = false
    private var links: [String: FilterLink]?
    
    var isCollection: Bool {
        return collectionIdentifier != nil
    }
    
    var collectionIdentifier: String? {
        return links?["page"]?.collectionIdentifier
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "display"
        case value
        case isDefault = "default"
        case links = "_links"
    }
}

extension FilterOption: Equatable { }

public func == (lhs: FilterOption, rhs: FilterOption) -> Bool {
    return lhs.value == rhs.value && lhs.title == rhs.title
}

// MARK: CustomDebugStringConvertible

extension FilterOption: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "NPOKit.FilterOption(title: \"\(title)\")"
    }
}
