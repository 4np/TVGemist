//
//  Filter.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 14/12/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public struct Filter: Codable {
    public private(set) var title: String
    public private(set) var type: String
    internal var argumentName: String
    public private(set) var options = [FilterOption]()
    
    enum CodingKeys: String, CodingKey {
        case title
        case type = "filterType"
        case argumentName = "filterArgument"
        case options
    }
}

extension Filter: Equatable { }

public func == (lhs: Filter, rhs: Filter) -> Bool {
    return lhs.type == rhs.type && lhs.argumentName == rhs.argumentName
}

// MARK: CustomDebugStringConvertible

extension Filter: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "NPOKit.Filter(title: \"\(title)\", options: \(options))"
    }
}
