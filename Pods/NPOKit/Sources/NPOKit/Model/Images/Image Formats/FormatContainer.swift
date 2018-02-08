//
//  FormatContainer.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 27/10/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

struct FormatContainer: Codable {
    var original: Format?
    var tv: Format?
    var expanded: Format?
    var maf: Format?
    var phone: Format?
    var tablet: Format?
    var web: Format?
    
    enum CodingKeys: String, CodingKey {
        case original
        case tv
        case expanded = "tv-expanded"
        case maf
        case phone
        case tablet
        case web
    }
}
