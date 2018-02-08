//
//  GenreItem.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 27/10/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public struct GenreItem: Codable {
    var id: String
    public private(set) var terms: [String]
}
