//
//  LiveEPG.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 09/02/2018.
//

import Foundation

public struct LiveEPG: Codable {
    public private(set) var schedules: [LiveSchedule]
    public private(set) var channel: LiveChannel
    
    enum CodingKeys: String, CodingKey {
        case schedules = "schedule"
        case channel
    }
}

extension LiveEPG {
    public var currentSchedule: LiveSchedule? {
        let now = Date()
        return schedules.first(where: { $0.starts <= now && $0.ends > now })
    }
    
    public var nextSchedule: LiveSchedule? {
        guard
            let currentSchedule = currentSchedule,
            let index = schedules.index(where: { $0 == currentSchedule }),
            (index + 1) < schedules.count
            else { return nil }
        
        return schedules[index + 1]
    }
}

extension LiveEPG: Equatable { }

public func == (lhs: LiveEPG, rhs: LiveEPG) -> Bool {
    return lhs.channel == rhs.channel
}
