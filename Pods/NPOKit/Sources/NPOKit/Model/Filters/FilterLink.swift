//
//  FilterLink.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 18/12/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

struct FilterLink: Codable {
    internal var href: URL
    internal var collectionIdentifier: String?
    
    enum CodingKeys: String, CodingKey {
        case href
        case collectionIdentifier = "collectionId"
    }
}
