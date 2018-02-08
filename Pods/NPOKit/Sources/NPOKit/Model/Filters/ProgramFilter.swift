//
//  ProgramFilter.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 18/12/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public struct ProgramFilter {
    public var filter: Filter
    public var option: FilterOption
    
    public init(filter: Filter, option: FilterOption) {
        self.filter = filter
        self.option = option
    }
}

extension ProgramFilter: Equatable { }

public func == (lhs: ProgramFilter, rhs: ProgramFilter) -> Bool {
    return lhs.filter == rhs.filter && lhs.option == rhs.option
}
