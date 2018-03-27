//
//  Filter.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 14/12/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public enum FilterType: Int, Codable {
    case date
    case genre
    case alphabet
    case unknown
}

public struct Filter: Codable {
    public private(set) var title: String
    internal var controlType: String
    internal var argumentName: String
    public private(set) var options = [FilterOption]()
    
    public var type: FilterType {
        switch argumentName {
        case "az":
            return .alphabet
        case "genreId":
            return .genre
        case "dateFrom":
            return .date
        default:
            return .unknown
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case controlType = "filterType"
        case argumentName = "filterArgument"
        case options
    }
}

// MARK: Equatable

extension Filter: Equatable { }

public func == (lhs: Filter, rhs: Filter) -> Bool {
    return lhs.type == rhs.type && lhs.argumentName == rhs.argumentName
}

// MARK: Comparable

extension Filter: Comparable {
    public static func < (lhs: Filter, rhs: Filter) -> Bool {
        return lhs.type.rawValue < rhs.type.rawValue
    }
}

// MARK: CustomDebugStringConvertible

extension Filter: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "NPOKit.Filter(title: \"\(title)\", options: \(options))"
    }
}
