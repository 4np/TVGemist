//
//  LiveSchedule.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 09/02/2018.
//

import Foundation

public struct LiveSchedule: Codable {
    public private(set) var starts: Date
    public private(set) var ends: Date
    public private(set) var isHighlighted = false
    public private(set) var program: Item?
    
    public var startTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: starts)
    }
    
    public var endTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: ends)
    }
    
    enum CodingKeys: String, CodingKey {
        case starts = "startsAt"
        case ends = "endsAt"
        case isHighlighted = "highlighted"
        case program
    }
}

extension LiveSchedule: Equatable { }

public func == (lhs: LiveSchedule, rhs: LiveSchedule) -> Bool {
    return lhs.starts == rhs.starts && lhs.ends == rhs.ends
}
